<?php
// Get the current URL
$currentUrl = "https://" . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
// Remove the 'pass' query parameter from the URL
$currentUrlWithoutPass = preg_replace('/\?pass=.*$/', '', $currentUrl);

// Calculate the MD5 hash of the current URL
$expectedHash = md5($currentUrlWithoutPass);

// Check if the 'pass' query parameter is set and matches the expected hash
if (!isset($_GET['pass']) || $_GET['pass'] !== $expectedHash) {
    header('HTTP/1.1 403 Forbidden');
    echo json_encode(array("error" => "Forbidden: Invalid hash"));
    exit;
}

// Function to get disk usage in percent for all useful mounted filesystems
function getDiskUsage() {
    $mounts = file('/proc/mounts');
    $diskData = array();
    $excludedMounts = array('/run', '/boot', '/tmp', '/var/tmp', '/var/run');
    foreach ($mounts as $mount) {
        $parts = preg_split('/\s+/', $mount);
        $disk = $parts[1]; // Get the mount point
        if (is_dir($disk) && !in_array($disk, $excludedMounts) && strpos($disk, '/sys') !== 0 && strpos($disk, '/proc') !== 0 && strpos($disk, '/dev') !== 0 && strpos($disk, '/snap') !== 0) {
            $diskTotalSpace = @disk_total_space($disk);
            $diskFreeSpace = @disk_free_space($disk);
            if ($diskTotalSpace === false || $diskFreeSpace === false || $diskTotalSpace == 0) {
                echo "Error getting disk space for mount point: $disk\n";
                continue;
            }
            $diskUsedSpace = $diskTotalSpace - $diskFreeSpace;
            $diskUsagePercent = ($diskUsedSpace / $diskTotalSpace) * 100;
            $diskData[$disk] = array(
                "used_space" => $diskUsedSpace,
                "used_space_gb" => round($diskUsedSpace / (1024 ** 3), 2),
                "total_space" => $diskTotalSpace,
                "total_space_gb" => round($diskTotalSpace / (1024 ** 3), 2),
                "usage_percent" => round($diskUsagePercent, 2)
            );
        }
    }
    return $diskData;
}

// Function to get memory RAM usage in percent
function getMemoryUsage() {
    $memoryInfo = file_get_contents("/proc/meminfo");
    preg_match("/MemTotal:\s+(\d+)/", $memoryInfo, $totalMatches);
    preg_match("/MemAvailable:\s+(\d+)/", $memoryInfo, $availableMatches);
    $totalMemory = $totalMatches[1];
    $availableMemory = $availableMatches[1];
    $usedMemory = $totalMemory - $availableMemory;
    $memoryUsagePercent = ($usedMemory / $totalMemory) * 100;
    return array(
        "used_memory" => $usedMemory,
        "used_memory_gb" => round($usedMemory / (1024 ** 2), 2),
        "total_memory" => $totalMemory,
        "total_memory_gb" => round($totalMemory / (1024 ** 2), 2),
        "usage_percent" => round($memoryUsagePercent, 2)
    );
}

// Function to get CPU usage in percent
function getCpuUsage() {
    $load = sys_getloadavg();
    $cpuCores = shell_exec("nproc"); // Get the number of CPU cores
    $cpuUsagePercent = ($load[0] / $cpuCores) * 100;
    return array(
        "load_average" => $load[0],
        "cpu_cores" => (int)$cpuCores,
        "usage_percent" => round($cpuUsagePercent, 2)
    );
}

// Gather data
$data = array(
    "disk_usage" => getDiskUsage(),
    "memory_usage" => getMemoryUsage(),
    "cpu_usage" => getCpuUsage()
);

// Encode data to JSON format
$jsonData = json_encode($data, JSON_PRETTY_PRINT);

// Output JSON data
header('Content-Type: application/json');
echo $jsonData;
?>
