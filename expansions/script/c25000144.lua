--小提琴超兽 吉根
local m=25000144
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	 aux.AddFusionProcFun2(c,cm.ffilter1,cm.ffilter2,false)
 --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
--ne
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+10000)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+20000)
	e3:SetCondition(cm.pencon) 
	e3:SetTarget(cm.pentg)
	e3:SetOperation(cm.penop)
	c:RegisterEffect(e3)
end
function cm.ffilter1(c)
	return c:IsSetCard(0xaf6) and c:IsType(TYPE_PENDULUM)
end
function cm.ffilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_FIEND)
end

function cm.costfilter(c,e,tp,mg)
	if not (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_FUSION) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and  Duel.GetLocationCountFromEx(tp,tp,mg,c)>0) then return false end
	return c:GetLeftScale()>0  and  mg:CheckSubGroup(cm.fselect,2,c:GetLeftScale(),c:GetLeftScale(),tp)
end
function cm.fselect(g,sc,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetLeftScale,sc)
	else return false end
end
function cm.tefilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:GetLeftScale()>0 and c:IsAbleToDeck()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_EXTRA,0,nil)   
	if chk==0 then return mg:CheckSubGroup(cm.fselect,1,c:GetLeftScale(),c:GetLeftScale(),tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_EXTRA,0,nil)   
	if not (c:IsRelateToEffect(e) and mg:CheckSubGroup(cm.fselect,1,c:GetLeftScale(),c:GetLeftScale(),tp)) then return end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=mg:SelectSubGroup(tp,cm.fselect,false,1,c:GetLeftScale(),c:GetLeftScale(),tp)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function cm.ckfilter(c,tp)
	return  c:IsControler(1-tp) and aux.disfilter1(c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
 return  eg:IsExists(cm.ckfilter,1,nil,tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,TYPE_PENDULUM) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0  end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,nil,0,0)   
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,TYPE_PENDULUM)  then   
	return  
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,TYPE_PENDULUM)
	local tc=g:GetFirst()
	local ss=0
	if tc:IsLocation(LOCATION_HAND) then 
	Duel.SendtoExtraP(tc,nil,REASON_DESTROY+REASON_EFFECT)
	ss=1
	else
	Duel.Destroy(tc,REASON_EFFECT)
	ss=1
	end
	if ss==1 then 
	   local tc1=eg:GetFirst()
	  while tc1 do
			if tc1:IsControler(1-tp) and aux.disfilter1(tc1) then
			Duel.NegateRelatedChain(tc1,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(RESET_TURN_SET)
			tc1:RegisterEffect(e2) 
			end
	  tc1=eg:GetNext()
	  end 
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g2:GetCount()==0 then return end
	local sg=g2:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	end
end

function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
