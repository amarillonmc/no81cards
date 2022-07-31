--宇宙勇机 雄伟左轮
local m=40010436
local cm=_G["c"..m]
cm.named_with_CosmosHero=1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	c:RegisterEffect(e1)   
	--to hand/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.tdcon)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e5)	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function cm.thfilter(c)
	return c:IsSetCard(0x1163) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.rfilter(c,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and c:IsLevelAbove(1) and c:IsSetCard(0x1163)
end
function cm.mnfilter(c,g,lv)
	return g:IsExists(cm.mnfilter2,1,c,c,lv)
end
function cm.mnfilter2(c,mc,lv)
	return c:GetLevel()-mc:GetLevel()==lv
end
function cm.spfilter(c,e,tp,g)
	return c:IsSetCard(0x1163) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.spfilter1(c,e,tp,g)
	return cm.spfilter(c,e,tp,g) and g:IsExists(cm.mnfilter,1,nil,g,c:GetLevel())
end
function cm.spfilter2(c,e,tp,lv)
	return cm.spfilter(c,e,tp,nil) and c:IsLevel(lv)
end
function cm.fselect(g,e,tp)
	return g:GetCount()==2 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	local g=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil,tp)
	local b2=g:CheckSubGroup(cm.fselect,2,2,e,tp)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	elseif b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if e:GetLabel()==1 then
		local g=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g:SelectSubGroup(tp,cm.fselect,false,2,2,e,tp)
		if rg and rg:GetCount()==2 then
			local c1=rg:GetFirst()
			local c2=rg:GetNext()
			local lv=c1:GetLevel()-c2:GetLevel()
			if lv<0 then lv=-lv end
			if Duel.Release(rg,REASON_EFFECT)==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
				if sg:GetCount()>0 then
					Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousSetCard(0x1163) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0 and c:GetPreviousControler()==tp
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and bit.band(r,REASON_DESTROY)~=0 and rp==1-tp
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return #g>7 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,#g-7,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if ct<=7 or #g==0 then return end
	local tct=math.min(ct-7,#g)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local sg=g:Select(1-tp,tct,tct,nil)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
end
