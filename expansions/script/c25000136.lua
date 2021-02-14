--毒蛾超兽 多拉格里
local m=25000136
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	 --ct
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCountLimit(1,m)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTarget(cm.pentg)
	e0:SetOperation(cm.penop)
	c:RegisterEffect(e0)
 --sc fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m+10000)
	e3:SetCost(cm.spcost3)
	e3:SetTarget(cm.sptg3)
	e3:SetOperation(cm.spop3)
	c:RegisterEffect(e3)
end
function cm.spfilter(c,e,tp,code)
	return c:IsSetCard(0xaf6) and c:IsType(TYPE_PENDULUM) and c:GetCode()~=code and (c:IsFaceup()
   or c:IsLocation(LOCATION_HAND)) and not c:IsForbidden() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.pcfilter(c,code)
	return  c:IsSetCard(0xaf6) and c:IsType(TYPE_PENDULUM) and c:GetCode()~=code and (c:IsFaceup()
   or c:IsLocation(LOCATION_HAND)) and not c:IsForbidden()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetCode())
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e:GetHandler():GetCode())
	if chk==0 then return   b1 or b2 end  
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.desfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_PENDULUM)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end   
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetCode())
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e:GetHandler():GetCode())
	local dg
	if b1 or (b2 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	 dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	elseif b2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	 dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_PZONE,0,1,1,nil)
	else return 
	end
	if  dg and Duel.Destroy(dg,REASON_EFFECT)==0 then return  end
	local op=0
	if b1 and b2
		then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler():GetCode())
		if g:GetCount()>0 then
			 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else		 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e:GetHandler():GetCode())
		if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

function cm.costfilter(c,e,tp,mg)
	if not (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_FUSION) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and  Duel.GetLocationCountFromEx(tp,tp,mg,c)>0) then return false end
	return c:GetLeftScale()>0  and  mg:CheckSubGroup(cm.fselect,2,c:GetLeftScale(),c:GetLeftScale(),tp)
end
function cm.fselect(g,sc,tp)
	local mg=g:Clone()
	if Duel.GetMZoneCount(tp,mg)>0 then
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetLeftScale,sc)
	else return false end
end
function cm.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.tefilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>0 and c:IsAbleToExtra()
end
function cm.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)   
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rg)  and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)   
	if not (Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)  and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)) then return end  
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g1:GetFirst()
	if tc then
	local g=mg:SelectSubGroup(tp,cm.fselect,false,2,tc:GetLeftScale(),tc:GetLeftScale(),tp)
	if Duel.SendtoExtraP(g,nil,REASON_EFFECT)==g:GetCount() then	   
			tc:SetMaterial(nil)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
			end
	end
	end
end

