--第一次接触
local m=33400653
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m+10000)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.activate)
	c:RegisterEffect(e0)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return  c:IsAbleToRemove()
end
function cm.sfilter1(c)
	return c:IsSetCard(0x9342) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.sfilter2(c)
	return   c:IsSetCard(0xc342) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()   
	local ss=0
	if  tc:GetLocation()~=LOCATION_GRAVE then ss=1 end 
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then 
		 if tc:IsSetCard(0x9342) and Duel.IsExistingMatchingCard(cm.sfilter1,tp,LOCATION_DECK,0,1,nil) then 
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				  local tg1=Duel.SelectMatchingCard(tp,cm.sfilter1,tp,LOCATION_DECK,0,1,1,nil)
				  local tc1=tg1:GetFirst()
				  if  Duel.SSet(tp,tc1)~=0 and ss==1 then 
					   local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc1:RegisterEffect(e1)
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc1:RegisterEffect(e2)
				  end 
			 end
		 end
		 if tc:IsSetCard(0xc342) and Duel.IsExistingMatchingCard(cm.sfilter2,tp,LOCATION_DECK,0,1,nil) then 
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				  local tg2=Duel.SelectMatchingCard(tp,cm.sfilter2,tp,LOCATION_DECK,0,1,1,nil)
				  local tc2=tg2:GetFirst()
				  if  Duel.SSet(tp,tc2)~=0 and ss==1 then 
					   local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc2:RegisterEffect(e1)
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc2:RegisterEffect(e2)
				  end 
			 end
		 end
	end 
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.refilter(c)
	return c:IsSetCard(0x9342,0xc342)  and c:IsAbleToRemove()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xc342)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)  
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local tg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end   
	end 
end