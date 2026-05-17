--底噪石窟-叠嶂无形
local s,id,o=GetID()
local SET_BOTTOMNOISE=0x5d71
local CARD_BOTTOMNOISE_CAVERN=21401270
local CARD_EVIL_LIQUID=21401281
local FUSION_MATERIAL_COUNT=4

function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--special summon procedure
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(s.fuscon)
	e0:SetOperation(s.fusop)
	c:RegisterEffect(e0)

	--① cannot direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--① cannot select battle target except "底噪石窟"
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)

	--② opponent cannot choose other monsters as attack targets
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.atlimit2)
	c:RegisterEffect(e3)

	--③ Special Summon itself from GY when attack is declared
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

--self Special Summon procedure
function s.matfilter(c)
	return c:IsFaceup()
		and c:IsCode(CARD_BOTTOMNOISE_CAVERN)
		and c:IsAbleToGraveAsCost()
end

function s.matgroup(tp)
	local oloc=0
	if Duel.IsPlayerAffectedByEffect(tp,CARD_EVIL_LIQUID) then
		oloc=LOCATION_ONFIELD
	end
	return Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,oloc,nil)
end

function s.fuscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=s.matgroup(tp)
	if g:GetCount()<FUSION_MATERIAL_COUNT then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return true end
	return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp,c)
	local ct=FUSION_MATERIAL_COUNT
	local g=s.matgroup(tp)
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
		sg:Merge(g1)
		g:Sub(g1)
		if ct-1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=g:Select(tp,ct-1,ct-1,nil)
			sg:Merge(g2)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sg=g:Select(tp,ct,ct,nil)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end

--①
function s.atlimit(e,c)
	return not (c:IsFaceup() and c:IsCode(CARD_BOTTOMNOISE_CAVERN))
end

--②
function s.atlimit2(e,c)
	return c~=e:GetHandler()
end

--③
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if chk==0 then
		return a and a:IsFaceup() and a:IsOnField()
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	e:SetLabelObject(a)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()

	--那只攻击怪兽的卡名当做「底噪石窟」使用
	if tc and tc:IsFaceup() and tc:IsOnField() and not tc:IsImmuneToEffect(e) then
		s.changecode(tc)
	end

	--这张卡特殊召唤
	if c:IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.changecode(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(CARD_BOTTOMNOISE_CAVERN)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
