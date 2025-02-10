util.AddNetworkString("Init_ASS")

hook.Add( "simfphysOnSpawn", "Simfphys_Willi302_Car_Spawned_SERVER", function( v )
	if v.ASS then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		
		net.Start( "Init_ASS" )
			net.WriteEntity( v )
			net.WriteFloat( v.ASS.Degree )
			net.WriteString( v.ASS.Bone )
			net.WriteFloat( v.ASS.Angle_P )
			net.WriteFloat( v.ASS.Angle_Y )
			net.WriteFloat( v.ASS.Angle_R )
		net.Send( rf )
	end
end )