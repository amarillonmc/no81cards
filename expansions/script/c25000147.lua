--异次元人 亚波人
local m=25000147
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --link summon  
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)  
	c:EnableReviveLimit()
--im
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(cm.con)
	e1:SetValue(cm.efilter1)
	c:RegisterEffect(e1)
 --cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(cm.con)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	 --search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.pentg)
	e3:SetOperation(cm.penop)
	c:RegisterEffect(e3)
--move
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+10000)
	e4:SetTarget(cm.mvtg)
	e4:SetOperation(cm.mvop)
	c:RegisterEffect(e4)
end
function cm.lcheck(g,lc)  
	return g:IsExists(cm.hspfilter,1,nil)  
end
function cm.hspfilter(c)
	return c:IsLinkType(TYPE_PENDULUM) and c:IsLinkType(TYPE_MONSTER) and c:IsSetCard(0xaf6)
end

function cm.efilter1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function cm.con(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,TYPE_PENDULUM)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp,zone)
	return c:IsSetCard(0xaf6) and c:IsType(TYPE_PENDULUM)  and (c:IsFaceup()
   or c:IsLocation(LOCATION_DECK)) and not c:IsForbidden() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.pcfilter(c)
	return  c:IsSetCard(0xaf6) and c:IsType(TYPE_PENDULUM) and (c:IsFaceup()
   or c:IsLocation(LOCATION_DECK)) and not c:IsForbidden()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp,zone)
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil)  
	if chk==0 then return   b1 or b2 end  
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.desfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_PENDULUM)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end   
	local zone=e:GetHandler():GetLinkedZone()
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp,zone)
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil)
	local op=0  
	if (b1 and zone>0) and (b2 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))
		then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif (b1 and zone>0) then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif (b2 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))) then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,zone)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	else		 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

function cm.cfilter(c,g)
	return c:IsType(TYPE_PENDULUM) and g:IsContains(c)	
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,lg)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,lg)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end