--魔王剑-嗫告篇帙-封印
local m=33400332
local cm=_G["c"..m]
function cm.initial_effect(c)
cm.dfc_front_side=m
cm.dfc_back_side=m+10
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.spcost)   
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
 --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.spcost2)
	e3:SetTarget(cm.thtg2)
	e3:SetOperation(cm.thop2)
	c:RegisterEffect(e3)
 --change code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetCondition(cm.reccon)
	e4:SetOperation(cm.changeop)
	c:RegisterEffect(e4)
 Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return c:IsSetCard(0x5341) or  c:IsLevelBelow(8) or c:IsRankBelow(8) or c:IsLinkBelow(3)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_DECK,0,nil)
	return  g:GetClassCount(Card.GetCode)==g:GetCount()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
 local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	Duel.ConfirmCards(tp,hg)
	Duel.ConfirmCards(1-tp,hg)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x5341) or  c:IsLevelBelow(8) or c:IsRankBelow(8) or c:IsLinkBelow(3))
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x6342) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c)
	return ((c:IsOnField() and c:IsFacedown()) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToDeck()
end
function cm.tgfilter(c)
	return  c:IsSetCard(0x6342) and c:IsAbleToGrave()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return true end
	local tdg=Duel.GetMatchingGroup(cm.filter2,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tdg:GetCount()>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)  end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsCode(ac) then 
	   local tdg=Duel.GetMatchingGroup(cm.filter2,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	   if tdg:GetCount()>0 then 
		  Duel.ConfirmCards(tp,tdg)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		  local tdg2=tdg:Select(tp,1,1,nil)
		  Duel.SendtoDeck(tdg2,nil,0,REASON_EFFECT) 
	   end
	else  
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		  if g1:GetCount()>0 then
		  Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		  end
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		  local g2=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		  Duel.SendtoGrave(g2,REASON_EFFECT)
	   end
	end
end

function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and   c:IsAbleToRemoveAsCost()end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.thfilter2(c)
	return (c:IsSetCard(0x9340) or c:IsCode(33400200)) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33420330)>0
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
end