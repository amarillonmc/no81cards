--冥导魔枪 双叉戟
local s,id=GetID()
s.named_with_InfernalLord=1

function s.InfernalLord(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.rittg)
	e1:SetOperation(s.ritop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.chcon)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)

end

function s.matfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsReleasable() and c:GetLevel()>0
end

function s.matfilter2(c)
	return s.InfernalLord(c) and c:IsAbleToGrave() and c:GetLevel()>0
end

function s.get_mat_group(tp)
	local mg=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if (pz0 and pz0:IsCode(40020547)) or (pz1 and pz1:IsCode(40020547)) then
		local mg2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_DECK,0,nil)
		mg:Merge(mg2)
	end
	return mg
end

function s.fselect(g,lv,tp)
	if g:GetSum(Card.GetLevel)~=lv then return false end
	local deck_g=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if #deck_g>0 and deck_g:GetClassCount(Card.GetCode)~=#deck_g then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==0 then return false end
	end
	return true
end
function s.ritfilter(c,e,tp,mg)
	if not (s.InfernalLord(c) and c:IsType(TYPE_RITUAL)) then return false end
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local lv=c:GetLevel()
	return mg:CheckSubGroup(s.fselect,1,#mg,lv,tp)
end

function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=s.get_mat_group(tp)
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local mg=s.get_mat_group(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.ritfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	
	if tc then
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_MATERIAL)
		local mat=mg:SelectSubGroup(tp,s.fselect,false,1,#mg,lv,tp)
		if not mat or #mat==0 then return end
		tc:SetMaterial(mat)
		local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #mat1>0 then
			Duel.Release(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if #mat2>0 then
			Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			if c:IsRelateToEffect(e) then
				Duel.Equip(tp,c,tc)

				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(s.eqlimit)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e3:SetCode(EVENT_LEAVE_FIELD)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetOperation(s.rmop)
				e3:SetLabelObject(tc)
				c:RegisterEffect(e3)
			end
		end
	end
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler():GetEquipTarget()
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return ep==tp
end
