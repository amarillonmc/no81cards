--永远的家人
local m=33401055
local cm=_G["c"..m]
function cm.initial_effect(c)
	   --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp,re)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and re:GetHandler():IsSetCard(0x9341)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,re) 
end
function cm.filter2(c,e,tp)
	return  c:IsSetCard(0xc342) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1500,REASON_EFFECT)
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	 local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	 end   
		  local e3=Effect.CreateEffect(e:GetHandler())
		  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e3:SetCode(EVENT_PHASE+PHASE_END)
		  e3:SetCountLimit(1)
		  e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e3:SetCondition(cm.tdcon)
		  e3:SetOperation(cm.tdop)
		  Duel.RegisterEffect(e3,tp)
end
function cm.ckfilter(c)
	return  c:IsSetCard(0x9341) and c:IsType(TYPE_FUSION) and c:GetOriginalAttribute()==ATTRIBUTE_FIRE and c:IsAbleToExtra()
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.ckfilter2(c,e,tp)
	return  c:IsSetCard(0x9341) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)   
	local dg=Duel.GetMatchingGroup(cm.ckfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if dg:GetCount()>0  and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)   
			local tdg=dg:Select(tp,1,dg:GetCount(),nil)			
			local tdg2=Duel.SendtoDeck(tdg,tp,2,REASON_EFFECT)
			local tc1=tdg2:GetFirst()
			local ct1=0
			local ct2=0
			while tc1 do
			if tc1:GetOwner()==tp then ct1=ct1+1 end 
			if tc1:GetOwner()==1-tp then ct2=ct2+1 end 
			tc1=tdg2:GetNext()
			end
			Duel.Recover(tp,ct1*1000,REASON_EFFECT)
			Duel.Recover(1-tp,ct2*1000,REASON_EFFECT)
			if ct1>0 and Duel.IsExistingMatchingCard(cm.ckfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local sl=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ct1*2<sl then sl=ct1*2 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)   
			local g=Duel.SelectMatchingCard(tp,cm.ckfilter2,tp,LOCATION_GRAVE,0,1,sl,nil,e,tp)   
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
			if ct2>0 and Duel.IsExistingMatchingCard(cm.ckfilter2,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			local sl=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
			if ct2*2<sl then sl=ct2*2 end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)   
			local g=Duel.SelectMatchingCard(1-tp,cm.ckfilter2,1-tp,LOCATION_GRAVE,0,1,sl,nil,e,1-tp)   
			Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		end
end

function cm.filter(c,e,tp)
	return  c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and ((c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp) or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)))
		and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) 
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and cm.filter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(cm.filter,1,nil,e,tp) and  e:GetHandler():IsSSetable()  end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end