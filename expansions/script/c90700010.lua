local m=90700010
local cm=_G["c"..m]
cm.name="鬼计堕天使"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	local enum=Effect.CreateEffect(c)
	enum:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	enum:SetCode(EVENT_ADJUST)
	enum:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	enum:SetRange(LOCATION_EXTRA)
	enum:SetOperation(cm.enumop)
	enum:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(enum)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(90700010)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.wincon)
	e1:SetOperation(cm.winop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90700010,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90700010,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,90700010)
	e3:SetCondition(cm.serstcon)
	e3:SetTarget(cm.sersttg)
	e3:SetOperation(cm.serstop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(90700010,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.sermcost)
	e4:SetTarget(cm.sermtg)
	e4:SetOperation(cm.sermop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetDescription(aux.Stringid(90700010,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetTarget(cm.rectg)
	e5:SetOperation(cm.recop)
	c:RegisterEffect(e5)
end
function cm.enumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0x1ff,0,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsCode(36239585) then--36239585 yaojing 
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.enumcon)
			e1:SetDescription(aux.Stringid(90700010,5))
			e1:SetTarget(cm.enumtg1)
			e1:SetOperation(cm.enumop1)
			tc:RegisterEffect(e1)
		end
		if tc:IsCode(46925518) then--46925518 renou
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.enumcon)
			e1:SetDescription(aux.Stringid(90700010,8))
			e1:SetTarget(cm.enumtg2)
			e1:SetOperation(cm.enumop2)
			tc:RegisterEffect(e1)
		end
		if tc:IsCode(51196805) then--51196805 kulou
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.enumcon)
			e1:SetDescription(aux.Stringid(90700010,9))
			e1:SetTarget(cm.enumtg3)
			e1:SetOperation(cm.enumop3)
			tc:RegisterEffect(e1)
		end
		if tc:IsCode(72913666) then--72913666 langren
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.enumcon)
			e1:SetDescription(aux.Stringid(90700010,11))
			e1:SetTarget(cm.enumtg4)
			e1:SetOperation(cm.enumop4)
			tc:RegisterEffect(e1)
		end
		if tc:IsCode(80885284) then--80885284 jiangshi
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.enumcon)
			e1:SetDescription(aux.Stringid(90700010,12))
			e1:SetTarget(cm.enumtg5)
			e1:SetOperation(cm.enumop5)
			tc:RegisterEffect(e1)
		end
		if tc:IsCode(84472026) then--84472026 xuenan
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.enumcon)
			e1:SetDescription(aux.Stringid(90700010,13))
			e1:SetTarget(cm.enumtg6)
			e1:SetOperation(cm.enumop6)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function cm.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8d)
end
function cm.enumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,90700010)
end
function cm.sefilter1(c)
	return c:IsSetCard(0x8d) and c:IsSSetable()
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x8d) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) or c:IsSSetable())
end
function cm.posfilter1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.enumtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.setfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.setfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_POSITION)
	end
end
function cm.enumop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local res=false
	if tc:IsType(TYPE_MONSTER) then
		res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		res=Duel.SSet(tp,tc)
	end
	if res~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil)
		if ct>0 and Duel.IsExistingMatchingCard(cm.posfilter1,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,cm.posfilter1,tp,0,LOCATION_MZONE,1,ct,nil)
			Duel.HintSelection(g)
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
function cm.enumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.enumop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.condition2)
	e1:SetOperation(cm.operation2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0x8d) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local ct=Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_DECK,0,nil,e,tp,ct)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,7)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		if Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function cm.enumtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.enumop3(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(cm.sfilter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct1>ct2 then ct1=ct2 end
	if ct1==0 then return end
	local t={}
	for i=1,ct1 do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,10))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	local g=Duel.GetDecktopGroup(1-tp,ac)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function cm.enumtg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,ct*100)
end
function cm.enumop4(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Damage(p,ct*100,REASON_EFFECT)
end
function cm.thfilter5(c,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x8d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.enumtg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=Duel.GetMatchingGroupCount(cm.sfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(cm.thfilter5,tp,LOCATION_DECK,0,1,nil,count)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.enumop5(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetMatchingGroupCount(cm.sfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter5,tp,LOCATION_DECK,0,1,1,nil,count)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.enumtg6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.enumop6(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,14))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
function cm.winfilter(c)
	local res=0
	if c:IsSetCard(0x8d) and c:IsPosition(POS_FACEUP) then
		res=1
	end
	return res
end
function cm.check(g)
	return g:GetCount()>=6 and g:GetClassCount(Card.GetCode)>=6 and g:GetSum(cm.winfilter)>=6
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	return cm.check(Duel.GetFieldGroup(tp,LOCATION_SZONE,0)) or cm.check(Duel.GetFieldGroup(tp,0,LOCATION_SZONE))
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local winmessage = 0x60
	local g1=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_SZONE)
	local wtp=cm.check(g1)
	local wntp=cm.check(g2)
	if wtp and not wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Win(tp,winmessage)
	elseif not wtp and wntp then
		Duel.ConfirmCards(tp,g2)
		Duel.Win(1-tp,winmessage)
	elseif wtp and wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		Duel.Win(PLAYER_NONE,winmessage)
	end
end
function cm.spcostfliter(c)
	return c:IsSetCard(0x8d) and c:IsAbleToGraveAsCost()
end
function cm.spfilter(c)
	return c:IsSetCard(0x8d) and c:IsDiscardable() and c:IsType(TYPE_MONSTER) and Duel.GetMatchingGroupCount(cm.spcostfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)>=c:GetLevel()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(cm.spfilter,tp,LOCATION_HAND,0,nil)>0 and Duel.GetLocationCountFromEx(tp)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	local lv=tc:GetLevel()
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
	e:GetHandler():RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,lv)
end
function cm.serstfilter(c)
	return c:IsSetCard(0x8d) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.serstfilter2(c)
	return c:IsSetCard(0x8d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsPosition(POS_FACEUP)
end
function cm.serstcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA and e:GetHandler():GetFlagEffect(m+100)>0
end
function cm.sersttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.serstop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90700010,1))
	local lv=e:GetHandler():GetFlagEffectLabel(m+100)
	local g2=Duel.SelectMatchingCard(tp,cm.spcostfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,lv,lv,nil)
	Duel.Overlay(e:GetHandler(),g2)
end
function cm.sermfilter1(c)
	return c:IsPosition(POS_FACEUP) and c:IsSetCard(0x8d) and c:IsAbleToGraveAsCost()
end
function cm.sermcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sermfilter1,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.sermfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.sermfilter2(c)
	return c:IsSetCard(0x8d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.sermtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sermfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.sermop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.sermfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.recfilter(c)
	return c:IsSetCard(0x8d) and c:IsAbleToHand()
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.recfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.recfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
