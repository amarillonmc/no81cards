--「歌姬」 诱宵美九
local m=33400909
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --link summon
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit()
	 --atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(cm.con1)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e0)
  --cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
 --
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
   --
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.con4)
	e4:SetTarget(cm.thtg1)
	e4:SetOperation(cm.thop1)
	c:RegisterEffect(e4)
  --indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetCondition(cm.con5)
	e5:SetTarget(cm.target)
	e5:SetValue(cm.indct)
	c:RegisterEffect(e5)
   --
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.con6)
	e6:SetTarget(cm.thtg2)
	e6:SetOperation(cm.thop2)
	c:RegisterEffect(e6)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc341)
end

function cm.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x341,0x340) and c:IsType(TYPE_CONTINUOUS)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil) 
	return g:GetCount()>0
end
function cm.atkfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x341,0x340) and (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS))
end
function cm.val(e,c)
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	return g:GetCount()*500
end

function cm.con2(e)
   local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil) 
	return g:GetCount()>1
end
function cm.tglimit(e,c)
	return c:IsSetCard(0x341)
end

function cm.con3(e)
   local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil) 
	return g:GetCount()>2
end
function cm.thfilter(c)
	return c:IsSetCard(0x341)  and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.spfilter1(c,e,tp)
	return  c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g2:GetCount()>0 then
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end

function cm.con4(e)
   local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil) 
	return g:GetCount()>3
end
function cm.thfilter2(c)
	return c:IsSetCard(0x340,0x341)  and c:IsType(TYPE_CONTINUOUS)  and not c:IsForbidden()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end

function cm.con5(e)
   local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil) 
	return g:GetCount()>4
end
function cm.target(e,c)
	return c:IsSetCard(0x341,0x340)
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end

function cm.con6(e)
   local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil) 
	return g:GetCount()>5
end
function cm.tdfilter(c)
	return c:IsSetCard(0x340,0x341)  and c:IsType(TYPE_CONTINUOUS+TYPE_FIELD)  and c:IsAbleToRemove()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then 
		return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,6,nil)
	end
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
if not Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,6,nil) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,6,6,nil)   
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
	   --update_attck
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetValue(cm.atkvl)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
   --update_def
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(1000807,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.atktg)
	e2:SetValue(cm.atkvl)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
--
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(cm.tg)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(cm.efilter)
	Duel.RegisterEffect(e3,tp)
	end
end
function cm.atktg(e,c)
	return c:IsSetCard(0x341)
end
function cm.ckfilter3(c)
	return c:IsSetCard(0x340,0x341)  and c:IsFaceup()
end
function cm.atkvl(e,c)
local g=Duel.GetMatchingGroup(cm.ckfilter3,tp,LOCATION_ONFIELD,0,nil)
   return g:GetCount()*1000
end
function cm.tg(e,c)
	return c:IsSetCard(0x341,0x340) and c:IsFaceup()
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end