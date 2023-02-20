local m=15000000
function Satl_TableClone(tab,mytab)
	local res=mytab or {}
	for i,v in pairs(tab) do
		res[i]=v
	end
	return res
end
Satl_Card=Satl_TableClone(Card)
Satl_Group=Satl_TableClone(Group)
Satl_Effect=Satl_TableClone(Effect)
Satl_Duel=Satl_TableClone(Duel)