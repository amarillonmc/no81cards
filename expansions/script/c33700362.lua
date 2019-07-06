--虚拟YouTuber的生放送
local m=33700362
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsSetCard(0x445) and tc:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local mg=tc:GetMaterial()
	local sg=mg:Filter(cm.spfilter,nil,e,tp,tc)
	if chk==0 then return #sg>0 and #sg==#mg and (#sg==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=#sg end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function cm.spfilter(c,e,tp,tc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x8)==0x8 and c:GetReasonCard()==tc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local mg=tc:GetMaterial()
	local sg=mg:Filter(cm.spfilter,nil,e,tp,tc)
	if #sg<1 or #sg~=#mg or (#sg>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) or Duel.GetLocationCount(tp,LOCATION_MZONE)<#sg then return end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	if ct<=0 then return end
	local g=Duel.GetOperatedGroup()
	for tc2 in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetValue(1)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc2:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc2:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc2:RegisterEffect(e4)
		c:SetCardTarget(tc2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_CANNOT_DISABLE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	g:KeepAlive()
	e1:SetLabelObject(g)
	e1:SetCondition(function(e) 
		local rg=e:GetHandler():GetCardTarget():Filter(Card.IsLocation,nil,LOCATION_MZONE) 
		if rg:GetCount()<=0 then e:Reset() return false end
		return true
	end
	)
	e1:SetOperation(function(e)
		local rg=e:GetHandler():GetCardTarget():Filter(Card.IsLocation,nil,LOCATION_MZONE) 
		Duel.Destroy(rg,REASON_EFFECT)
		e:Reset()
	end
	)
	tc:RegisterEffect(e1,true)
end

