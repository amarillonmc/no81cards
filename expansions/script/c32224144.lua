--鬼计骨女
function c32224144.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4,c32224144.ovfilter,aux.Stringid(32224144,0),4,c32224144.xyzop)
	c:EnableReviveLimit()
	--XyzSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32224144,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c32224144.setcon)
	e1:SetOperation(c32224144.xyzop2)
	c:RegisterEffect(e1)
	c32224144.xyzsummonable=true
	--XyzSummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAIN_END)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetOperation(c32224144.xyzop3)
	c:RegisterEffect(e0)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32224144,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,32224144)
	e2:SetCondition(c32224144.setcon)
	e2:SetTarget(c32224144.settg)
	e2:SetOperation(c32224144.setop)
	c:RegisterEffect(e2)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32224144,2))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,32224145)
	e4:SetCost(c32224144.poscost)
	e4:SetTarget(c32224144.postg)
	e4:SetOperation(c32224144.posop)
	c:RegisterEffect(e4)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetDescription(aux.Stringid(32224144,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetTarget(c32224144.tdtg)
	e5:SetOperation(c32224144.tdop)
	c:RegisterEffect(e5)
end
function c32224144.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8d) and not c:IsCode(32224144)
end
function c32224144.xyzop2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c32224144.xyzsummonable==true end
	if c32224144.xyzsummonable==true then
		if e:GetHandler():IsXyzSummonable(nil)
				and Duel.SelectYesNo(tp,aux.Stringid(32224144,0)) then
			Duel.XyzSummon(tp,e:GetHandler(),nil)
			c32224144.xyzsummonable=false
		end
		c32224144.xyzsummonable=false
	end
end
function c32224144.xyzop3(e,tp,eg,ep,ev,re,r,rp)
	c32224144.xyzsummonable=true
end
function c32224144.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,32224144)==0 end
	Duel.RegisterFlagEffect(tp,32224144,RESET_PHASE+PHASE_END,0,1)
end
function c32224144.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x8d) and rc:IsControler(tp) 
end
function c32224144.setfilter(c,e,tp)
	return c:IsSetCard(0x8d) and ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) or ((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and c:IsSSetable()))
end
function c32224144.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32224144.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c32224144.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c32224144.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	   and (not tc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
	   and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end
function c32224144.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c32224144.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c32224144.desfilter(c)
	return c:IsFaceup()
end
function c32224144.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c32224144.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c32224144.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32224144.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local ct=Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	local sg=Duel.GetMatchingGroup(c32224144.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c32224144.tdfilter(c)
	return c:IsSetCard(0x8d) and c:IsAbleToDeck()
end
function c32224144.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c32224144.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32224144.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c32224144.tdfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end
function c32224144.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
