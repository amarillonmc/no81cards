--萨尔贡·重装干员-森蚺
function c79029315.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(c79029315.distg)
	c:RegisterEffect(e1)  
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029315.atkval)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c79029315.spcon)
	e2:SetTarget(c79029315.sptg)
	e2:SetOperation(c79029315.spop)
	c:RegisterEffect(e2) 
end
function c79029315.distg(e,c)
	if e:GetHandler():GetSequence()==5 then
	return c:GetSequence()==2 or c:GetSequence()==3 or c:GetSequence()==4
	elseif e:GetHandler():GetSequence()==6 then
	return c:GetSequence()==0 or c:GetSequence()==1 or c:GetSequence()==2   
	else
	return e:GetHandler():GetColumnGroup():IsContains(c)
	end
end
function c79029315.atkfilter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(ec)
end
function c79029315.atkval(e,c)
	local g=Duel.GetMatchingGroup(c79029315.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	return g:GetSum(Card.GetLink)*e:GetHandler():GetOverlayCount()*1000
end
function c79029315.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c79029315.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029315.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local b1=Duel.CheckLocation(tp,LOCATION_MZONE,5)
	local b2=Duel.CheckLocation(tp,LOCATION_MZONE,6)
	local b3=c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)~=0
	if (b1 or b2 or b3) then
	if not Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.BreakEffect()
	local op=0
	if (b1 or b2) and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029315,0),aux.Stringid(79029315,1),aux.Stringid(79029315,2))
	elseif (b1 or b2) and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029315,0),aux.Stringid(79029315,1))  
	elseif (b1 or b2) then
	op=Duel.SelectOption(tp,aux.Stringid(79029315,0),aux.Stringid(79029315,2))   if op==1 then
	op=2
	end
	elseif b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029315,1),aux.Stringid(79029315,2))+1
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029315,2))+2
	end
	if op==0 then
	local x1=Duel.CheckLocation(tp,LOCATION_MZONE,5)
	local x2=Duel.CheckLocation(tp,LOCATION_MZONE,6)
	if x1 and x2 then
	Debug.Message("守住这里？唔，不难。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029315,5))
	op=Duel.SelectOption(tp,aux.Stringid(79029315,3),aux.Stringid(79029315,4))
	elseif x1 then
		op=Duel.SelectOption(tp,aux.Stringid(79029315,3))
	elseif x2 then
		op=Duel.SelectOption(tp,aux.Stringid(79029315,4))+1
	else
	return false
	end
	if op==0 then
	Duel.MoveSequence(e:GetHandler(),5)
	else
	Duel.MoveSequence(e:GetHandler(),6) 
	end
	elseif op==1 then
	Debug.Message("咬住你们了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029315,6))
	local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.Overlay(c,g)
	elseif op==2 then
	Debug.Message("我的力气也不小哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029315,7))
	--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c79029315.imfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end 
  end
end
end
function c79029315.imfilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end


















