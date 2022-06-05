local m=25000058
local cm=_G["c"..m]
cm.name="械晶霸主 超六方使"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_MACHINE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return rp~=tp end)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.immop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(function(e,te)return te:GetHandler()==e:GetLabelObject()end)
	e1:SetLabelObject(re:GetHandler())
	e:GetHandler():RegisterEffect(e1)
end
function cm.spfilter(c,e,tp)
	local ok=false
	for p=0,1 do
		local zone=Duel.GetLinkedZone(p)&0xff
		ok=ok or (Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone))
	end
	return ok
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone={}
	local flag={}
	for p=0,1 do
		zone[p]=Duel.GetLinkedZone(p)&0xff
		local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
		flag[p]=(~flag_tmp)&0x7f
	end
	local ft1=Duel.GetLocationCount(0,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[0])
	local ft2=Duel.GetLocationCount(1,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1])
	if ft1+ft2<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local ava_zone=0
	for p=0,1 do
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone[p]) then ava_zone=ava_zone|(flag[p]<<(p==tp and 0 or 16)) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~ava_zone))
	local sump=0
	if sel_zone&0xff>0 then sump=tp else
		sump=1-tp
		sel_zone=sel_zone>>16
	end
	if tc and Duel.SpecialSummonStep(tc,0,tp,sump,false,false,POS_FACEUP,sel_zone) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(c:GetCode())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:CopyEffect(c:GetCode(),RESET_EVENT+RESETS_STANDARD)
	end
	Duel.SpecialSummonComplete()
end
