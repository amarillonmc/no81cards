--完美防线
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174033
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:RegisterSolve(nil,nil,cm.target,cm.activate)
end
--[[function cm.cfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local seqlist={0,1,2,3,4}
	local disseq={}
	for _,seq in pairs(seqlist) do
		if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp,seq) then
			table.insert(disseq,seq+1)
		end
	end
	if chk==0 then return #disseq>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	rshint.Select(tp,{m,0})
	local seq=Duel.AnnounceNumber(tp,table.unpack(disseq))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
	e:SetLabel(seq)
end
function cm.tg(e,c)
	return aux.GetColumn(c,e:GetHandlerPlayer())==e:GetLabel()
end
function cm.val(e,re)
	return re:GetHandler():IsOnField() and aux.GetColumn(re:GetHandler(),e:GetHandlerPlayer())==e:GetLabel() and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.activate(e,tp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	local e1=rsef.FV_LIMIT({c,tp},"atk",nil,cm.tg,{LOCATION_MZONE,LOCATION_MZONE },nil,rsreset.pend)
	e1:SetLabel(seq)
	local e2=rsef.FV_LIMIT_PLAYER({c,tp},"act",cm.val,nil,{1,1},nil,rsreset.pend)
	e2:SetLabel(seq)
end--]]