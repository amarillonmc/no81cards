--龙仪巧-船尾流星＝PUP
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=11612639
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_cw
function c11612639.initial_effect(c)
	c:EnableReviveLimit()
	 --
	local e00=fpjdiy.Zhc(c,cm.text)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11612639,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c11612639.valcheck)
	c:RegisterEffect(e0)
 --cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(c11612639.rmlimit)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
--sucai
	--[[local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11612639,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11612639)
	e3:SetCondition(c11612639.xyzcon)
	e3:SetTarget(c11612639.xyztg)
	e3:SetOperation(c11612639.xyzop)
	c:RegisterEffect(e3)--]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11612639.matcon)
	e3:SetOperation(c11612639.matop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetCondition(c11612639.xyzcon)
	e4:SetTarget(c11612639.reptg)
	e4:SetValue(c11612639.repval)
	c:RegisterEffect(e4)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e4:SetLabelObject(g)
	e0:SetLabelObject(e3)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,116126390)
	e1:SetCost(c11612639.thcost)
	e1:SetTarget(c11612639.thtg)
	e1:SetOperation(c11612639.thop)
	c:RegisterEffect(e1)
end

function c11612639.repfilter(c,tp)
	return c:GetOwner()==1-tp and c:GetDestination()==LOCATION_GRAVE and c:GetLeaveFieldDest()==0 and c:IsReason(REASON_DESTROY)
end
function c11612639.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c11612639.repfilter,1,nil,tp) end
	if 1==1 then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(c11612639.repfilter,nil,tp)
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(11612639,RESET_EVENT+0x1fe0000-RESET_TOHAND-RESET_TODECK-RESET_LEAVE+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetValue(0x154)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOHAND-RESET_TODECK-RESET_LEAVE)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(c11612639.thcon2)
		e1:SetOperation(c11612639.thop2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		container:Merge(g)
		return true
	else return false end
end
function c11612639.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function c11612639.thfilter2(c)
	return c:GetFlagEffect(11612639)~=0
end
function c11612639.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11612639.thfilter2,1,nil)
end
function c11612639.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c11612639.thfilter2,nil)
	Duel.ConfirmCards(1-tp,g)
	g=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_MACHINE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.ShuffleHand(tp)
end
function c11612639.rmlimit(e,c,p)
	return c:IsControler(tp)
end
function c11612639.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c11612639.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c11612639.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11612639.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c11612639.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11612639,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11612639,0))
end
function c11612639.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11612639)>0
end
function c11612639.xyz1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end
function c11612639.xyz2filter(c)
	return (c:IsFacedown() or c:IsType(TYPE_MONSTER)) and c:IsCanOverlay()
end
function c11612639.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x154)
end
function c11612639.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	local g=Duel.GetFieldGroup(1-tp,0,LOCATION_EXTRA)
	if chk==0 then
	local ct=Duel.GetMatchingGroupCount(c11612639.cfilter,tp,LOCATION_MZONE,0,nil)
	e:SetLabel(ct)
	if ct==0 then return end
	if ct>3 then ct=3 end
	 return g:FilterCount(c11612639.xyz2filter,nil)>0 and Duel.IsExistingMatchingCard(c11612639.xyz1filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c11612639.xyz2filter,tp,0,LOCATION_EXTRA,1,ct,e:GetHandler())
end
function c11612639.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c11612639.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c11612639.xyz2filter,1-tp,LOCATION_EXTRA,0,nil)
	if ct==0 then return end
	if ct>3 then ct=3 end
	if g:GetCount()>=ct then
		local rg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):RandomSelect(1-tp,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,c11612639.xyz1filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Overlay(sg:GetFirst(),rg)
	end
end
function c11612639.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c11612639.tgfilter(c,tp)
	return c:IsCode(11612610,11612611,11612614,11612616,11612626,11612627,11612629,11612630,11612631,11612632,11612633) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c11612639.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c11612639.thfilter(c)
	return c:IsCode(11612628) and c:IsAbleToHand()
end
function c11612639.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11612639.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11612639.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11612639.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c11612639.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end