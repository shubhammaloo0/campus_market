import 'package:campus_market/HomeScreen/home_screen.dart';
import 'package:campus_market/Widgets/listview_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget{

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = '';
  bool _isSearching = false;

  Widget _buildSearchField()
  {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search here. . .',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white, fontSize: 16.0),

      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  updateSearchQuery(String newQuery)
  {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  List<Widget> _buildActions()
  {
    if(_isSearching)
    {
      return<Widget>
      [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: ()
          {
            if(_searchQueryController == null || _searchQueryController.text.isEmpty)
            {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>
    [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed:  _startSearch,
      ),
    ];
  }

  _clearSearchQuery()
  {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  _startSearch()
  {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState((){
      _isSearching = true;
    });
  }

  _stopSearching()
  {
    _clearSearchQuery();
    setState((){
      _isSearching = false;
    });
  }

  _buildTitle(BuildContext context)
  {
    return const Text('Search Product');
  }

  _buildBackButton()
  {
    return IconButton(
      icon : const Icon(Icons.arrow_back, color: Colors.black,),
      onPressed: ()
      {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen()));

      },
    );
  }



  @override
  Widget build(BuildContext context){
    return Container(
      decoration:const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.lightBlueAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      child: Scaffold(
        backgroundColor:Colors.transparent,
        appBar:AppBar(
          leading: _isSearching ? const BackButton() : _buildBackButton(),
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
          flexibleSpace:Container(
            decoration:const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.lightBlue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where('itemModel',isGreaterThanOrEqualTo: _searchQueryController.text.trim())
              .where('status' , isEqualTo: 'approved')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(),);

            }
            else if(snapshot.connectionState == ConnectionState.active)
            {
              if(snapshot.data!.docs.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return ListViewWidget(
                      docId: snapshot.data!.docs[index].id,
                      itemColor: snapshot.data!.docs[index]['itemColor'],
                      img1: snapshot.data!.docs[index]['urlImage1'],
                      img2: snapshot.data!.docs[index]['urlImage2'],
                      userImg: snapshot.data!.docs[index]['imgPro'],
                      name: snapshot.data!.docs[index]['userName'],
                      date: snapshot.data!.docs[index]['time'].toDate(),
                      userId: snapshot.data!.docs[index]['id'],
                      itemModel: snapshot.data!.docs[index]['itemModel'],
                      postId: snapshot.data!.docs[index]['postId'],
                      itemPrice: snapshot.data!.docs[index]['itemPrice'],
                      description : snapshot.data!.docs[index]['description'],
                      address : snapshot.data!.docs[index]['address'],
                      userNumber : snapshot.data!.docs[index]['userNumber'],
                    );
                  },
                );
              }
              else
              {
                return const Center(
                  child: Text('There is no tasks'),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          },
        ),

      ),
    );
  }
}