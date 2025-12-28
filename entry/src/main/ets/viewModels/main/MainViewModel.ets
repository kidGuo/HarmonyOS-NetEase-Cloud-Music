/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { TabBarItem } from '../../models/main/TabBarItem';

class MainViewModel {
  tabItems: TabBarItem[] = [
    {
      id: '2025001',
      name: '首页',
      color: '#838491',
      selectedColor: '#252534'
    },
    {
      id: '2025002',
      name: '搜索',
      color: '#838491',
      selectedColor: '#252534'
    },
    {
      id: '2025003',
      name: '笔记',
      color: '#838491',
      selectedColor: '#252534'
    },
    {
      id: '2025004',
      name: '我的',
      color: '#838491',
      selectedColor: '#252534'
    }
  ]
}

export default MainViewModel;