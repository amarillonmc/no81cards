--闪刀计划-盖尔斯
local m=60001101
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e0:SetValue(cm.acval)
	c:RegisterEffect(e0)
	--link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e1:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_RIGHT+LINK_MARKER_TOP_LEFT+LINK_MARKER_LEFT+LINK_MARKER_RIGHT)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetValue(cm.disval)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_DRAW)
		e4:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
		e4:SetOperation(cm.checkduelplayer)
		Duel.RegisterEffect(e4,tp)
	end
end

function cm.acval(e,tp,eg,ep,ev,re,r,rp)
	return 0x04
end

function cm.checkduelplayer(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOwner()==tp then 
		e:GetHandler():RegisterFlagEffect(m,0,0,1) 
	end
end

function cm.disval(e)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)~=0 then
		return 0x00000a0e
	else
		return 0x0a0e0000
	end
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function cm.tgsfilter1(c,e,tp)
	return c:IsLevel(1) and c:IsSetCard(0x115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.tgtfilter2(c)
	return c:IsLevel(1) and c:IsSetCard(0x115) and c:IsAbleToHand()
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(cm.tgsfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or Duel.IsExistingMatchingCard(cm.tgtfilter2,tp,LOCATION_DECK,0,1,nil) end
	if Duel.IsExistingMatchingCard(cm.tgsfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.IsExistingMatchingCard(cm.tgsfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) and (not Duel.IsExistingMatchingCard(cm.tgtfilter2,tp,LOCATION_DECK,0,1,nil) 
	or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,tgsfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,tgtfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end