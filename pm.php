<?php
  /**
   * This is the PHP equivalent ...
   */


require_once __DIR__.'/packages.php';

function flatten($arr)
{
  $collection = [];
  array_walk_recursive(
    $arr,
    function($i) use (&$collection)
    {
      return $collection[] = $i;
    }
  );
  return $collection;
}

function list_unique($arr)
{
  $collection = [];
  array_map(function($i) use (&$collection)
            {
              if(!in_array($i, $collection))
                {
                  $collection[] = $i;
                }
            }, $arr);
  return $collection;
}
  
function list_dependencies($x)
{
  global $dep;
  if(isset($dep[$x]))
    {
      return list_unique(flatten(
        array_reverse(
          array_filter(
            array_merge(
              $dep[$x], array_map('list_dependencies', $dep[$x]))))));
    }
}

function list_requires($x)
{
  global $dep;
  return list_unique(array_map(function($k) use ($x,$dep)
            {
              if(in_array($x, $dep[$k]))
                {
                  return $k;
                }
            }, array_keys($dep)));
}
  
if($argv[1] == 'deps')
  {
    echo $argv[2]." depends on:\n";
    array_map(function($d)
              { printf("%s\n",$d); },
              list_dependencies($argv[2]));
  }
else
  {
    echo "\n".$argv[2]." required for:\n";
    array_map(function($d)
              { printf("%s\n",$d); },
              list_requires($argv[2]));
  }
