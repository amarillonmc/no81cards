--Legend-Arms 玄羽
function c16300005.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,c16300005.matfilter,1,1)
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetValue(c16300005.matval)
	c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetValue(1)
	c:RegisterEffect(e00)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16300005)
	e1:SetTarget(c16300005.tgtg)
	e1:SetOperation(c16300005.tgop)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c16300005.val)
	c:RegisterEffect(e3)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_EQUIP)
	e33:SetCode(EFFECT_SET_DEFENSE)
	e33:SetValue(c16300005.val)
	c:RegisterEffect(e33)
end
function c16300005.matfilter(c)
	return c:IsLinkSetCard(0x3dc6) and c:IsType(0x1) or c:IsCode(16300000)
end
function c16300005.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return c:IsCode(16300000),true
end
function c16300005.val(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	return math.max(ec:GetBaseAttack(),ec:GetBaseDefense())
end
function c16300005.matfilter(c)
	return c:IsSetCard(0x3dc6) and c:IsType(0x1) or c:IsCode(16300000)
end
function c16300005.tgfilter(c,e,tp)
	return c:IsSetCard(0x3dc6) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToGrave() or c:IsAbleToRemove()
			or c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0)
end
function c16300005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16300005.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c16300005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ck=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c16300005.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local b1=tc:IsAbleToGrave()
		local b2=tc:IsAbleToRemove()
		local b3=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
		local op=aux.SelectFromOptions(tp,{b1,1191},{b2,1192},{b1,1152})
		if op==1 then
			if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(0x10) then ck=1 end
		elseif op==2 then
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(0x20) then ck=1 end
		elseif op==3 then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then ck=1 end
		end
	end
	if ck>0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp)
			and Duel.IsExistingMatchingCard(c16300005.eqfilter,tp,LOCATION_MZONE,0,1,c)
			and Duel.SelectYesNo(tp,aux.Stringid(16300005,0)) then
			local ec=Duel.SelectMatchingCard(tp,c16300005.eqfilter,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
			if ec then
				if not Duel.Equip(tp,c,ec) then return end
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c16300005.eqlimit)
				e1:SetLabelObject(ec)
				c:RegisterEffect(e1)
			end
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c16300005.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c16300005.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3dc6)
end
function c16300005.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c16300005.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR+RACE_DRAGON) and c:IsLocation(LOCATION_EXTRA)
end