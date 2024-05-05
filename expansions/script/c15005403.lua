local m=15005403
local cm=_G["c"..m]
cm.name="龙衣逆魂"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005397)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand(self)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.thcon2)
	e3:SetTarget(cm.thtg2)
	e3:SetOperation(cm.thop2)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,m))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.rmfilter(c,tp)
	return c:IsSetCard(0xaf3c) and c:IsAbleToRemove() and c:IsLevelAbove(1) and Duel.IsPlayerCanSpecialSummonMonster(tp,15005397,nil,TYPES_TOKEN_MONSTER,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),RACE_DRAGON,c:GetOriginalAttribute()) and Duel.GetMZoneCount(tp,c)>0
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xaf3c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function cm.mfilter(c,e)
	return c:IsLevelAbove(0) and c:IsType(TYPE_MONSTER) and c:IsDestructable(e) and c:IsCanBeRitualMaterial(nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local b1=Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,cm.filter,e,tp,mg,mg,Card.GetLevel,"Greater")
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local tcid=tc:GetFieldID()
			tc:RegisterFlagEffect(15005403,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,tcid,aux.Stringid(15005403,7))
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			if not Duel.IsPlayerCanSpecialSummonMonster(tp,15005397,nil,TYPES_TOKEN_MONSTER,tc:GetTextAttack(),tc:GetTextDefense(),tc:GetOriginalLevel(),RACE_DRAGON,tc:GetOriginalAttribute()) then return end
			local atk=tc:GetTextAttack()
			local def=tc:GetTextDefense()
			local lv=tc:GetOriginalLevel()
			local attr=tc:GetOriginalAttribute()
			local tkm=0
			if attr&ATTRIBUTE_LIGHT==ATTRIBUTE_LIGHT then tkm=15005401 end
			if attr&ATTRIBUTE_DARK==ATTRIBUTE_DARK then tkm=15005391 end
			if attr&ATTRIBUTE_EARTH==ATTRIBUTE_EARTH then tkm=15005397 end
			if attr&ATTRIBUTE_WATER==ATTRIBUTE_WATER then tkm=15005395 end
			if attr&ATTRIBUTE_FIRE==ATTRIBUTE_FIRE then tkm=15005393 end
			if attr&ATTRIBUTE_WIND==ATTRIBUTE_WIND then tkm=15005399 end
			if attr&ATTRIBUTE_DIVINE==ATTRIBUTE_DIVINE then tkm=15005402 end
			local token=Duel.CreateToken(tp,tkm)
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE)
				e2:SetValue(def)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e3:SetValue(attr)
				token:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_CHANGE_LEVEL)
				e4:SetValue(lv)
				token:RegisterEffect(e4)
				local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e5:SetCode(EVENT_LEAVE_FIELD)
				e5:SetOperation(cm.bedesop)
				e5:SetLabelObject(tc)
				e5:SetLabel(tcid)
				token:RegisterEffect(e5,true)
			end
			Duel.SpecialSummonComplete()
			tc:SetCardTarget(token)
		end
	else
		::cancel::
		local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		local sg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if sg then
				mg:Merge(sg)
			end
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat then goto cancel end
			tc:SetMaterial(mat)
			--Duel.ReleaseRitualMaterial(mat)
			Duel.Destroy(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsControler(tp) and ec:IsType(TYPE_TOKEN)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end