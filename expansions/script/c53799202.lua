local m=53799202
local cm=_G["c"..m]
cm.name="菓子工房代理店长 NYN"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)end)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>7 and Duel.GetDecktopGroup(tp,8):IsExists(Card.IsAbleToHand,1,nil) end
	local t={}
	Duel.Hint(24,0,aux.Stringid(m,1))
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac1=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac1)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,ac1,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac2=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	table.insert(t,ac2)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,ac1,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac2,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac3=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	table.insert(t,ac3)
	e:SetLabel(table.unpack(t))
	Duel.Hint(24,0,aux.Stringid(m,2))
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,1-tp,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<8 then return end
	Duel.ConfirmDecktop(tp,8)
	local g=Duel.GetDecktopGroup(tp,8)
	if #g==0 then return end
	local t={e:GetLabel()}
	table.insert(t,Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))
	local ag=Group.CreateGroup()
	for tc in aux.Next(g) do if SNNM.IsInTable(tc:GetCode(),t) then ag:AddCard(tc) end end
	local ct=8
	if #ag>0 then
		Duel.Hint(24,0,aux.Stringid(m,4))
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(ag,1-tp,REASON_EFFECT)~=0 then
			ct=ct-Duel.GetOperatedGroup():GetCount()
			Duel.ConfirmCards(tp,ag)
			Duel.ShuffleHand(1-tp)
		end
		Duel.SortDecktop(tp,tp,ct)
	else
		Duel.Hint(24,0,aux.Stringid(m,3))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(sg,tp,REASON_EFFECT)~=0 then
			ct=ct-1
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.SortDecktop(tp,tp,ct)
	end
end
