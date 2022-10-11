--沧龙唤士 克莉丝汀
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005111,"DragonCaller")
function cm.initial_effect(c)
	local e1,e2,e3=rsdc.SynchroFun(c,m,ATTRIBUTE_WATER,"td",rscost.reglabel(100),cm.tdtg,cm.tdop,cm.limit)   
end
function cm.limit(c,rc)
	return rc:IsOnField() and rc:IsFaceup()
end
function cm.gcheck(g,e,tp)
	local eqg=Group.CreateGroup()
	for tc in aux.Next(g) do
		eqg:Merge(tc:GetEquipGroup())
	end
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,#g,eqg)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp,true)
	if chk==0 then 
		return e:GetLabel()==100 and rg:CheckSubGroup(cm.gcheck,1,#rg,e,tp)
	end
	e:SetLabel(0)
	rshint.Select(tp,"res")
	local rg2=rg:SelectSubGroup(tp,cm.gcheck,false,1,#rg,e,tp)  
	local ct=Duel.Release(rg2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct,1-tp,LOCATION_ONFIELD)   
	e:SetValue(ct)
end
function cm.tdop(e,tp)
	local ct=e:GetValue()
	rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,ct,ct,nil,{})
end