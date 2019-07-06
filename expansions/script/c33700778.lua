--注目！缪恩的大魔法！
local m=33700778
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	 
end
cm.card_code_list={33700760}
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(33700770)
end
function cm.setfilter(c)
	return c:IsSetCard(0x344a) and not c:IsForbidden()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x344a) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsLocation(LOCATION_HAND) then ft=ft-1 end
	local b1=Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_MZONE,0,1,nil) and ft>0
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 or b3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	  e:SetCategory(0)
	elseif sel==2 then
	  e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
	else 
	  e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
	   e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
	   e:SetProperty(0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
	   local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	   if ft<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	   local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_MZONE,0,1,ft,nil)
	   if g:GetCount()<=0 then return end
	   for tc in aux.Next(g) do
		   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		   local e1=Effect.CreateEffect(c)
		   e1:SetCode(EFFECT_CHANGE_TYPE)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		   tc:RegisterEffect(e1)
		   tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,0,1)
	   end
	elseif sel==2 then
	   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	   if ft<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_SZONE,0,1,ft,nil,e,tp)
	   if g:GetCount()<=0 then return end
	   Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	else
	   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	   if ft<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,math.min(ft,2),nil,e,tp)
	   if g:GetCount()<=0 then return end
	   Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
