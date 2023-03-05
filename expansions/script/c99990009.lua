--超新星喷流龙 降星宇宙
local m=99990009
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
   --xyz summon
	aux.AddXyzProcedure(c,nil,12,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	--mat
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.xyzmattg)
	e5:SetOperation(cm.xyzmatop)
	c:RegisterEffect(e5)
end
function cm.cfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetOverlayCount()>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local tg=tc:GetOverlayGroup()
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end
	end
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,36,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,36,36,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,aux.ExceptThisCard(e))
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.cfilter2(c,tp,mc)
	local rank=c:GetRank()
	local ct=0
	if rank>mc then ct=rank-mc else ct=mc-rank end
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct and not c:IsLevel(0)
end
function cm.xyzmattg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=e:GetHandler():GetRank()
	if chk==0 then return eg:IsExists(cm.cfilter2,1,nil,tp,mc) end
end
function cm.xyzmatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mc=c:GetRank()
	local g=eg:Filter(cm.cfilter2,nil,tp,mc)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	tc=g:Select(tp,1,1,nil):GetFirst()
	local rank=tc:GetLevel()
	local ct=0
	if rank>mc then ct=rank-mc else ct=mc-rank end
	local mg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Overlay(c,mg)
end
function cm.atkval(e,c)
	return c:GetOverlayCount()*200
end
