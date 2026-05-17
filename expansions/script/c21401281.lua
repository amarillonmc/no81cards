--底噪石窟-诱解恶液
local s,id,o=GetID()
local SET_BOTTOMNOISE=0x5d71
local CARD_BOTTOMNOISE_CAVERN=21401270
local CARD_EVIL_LIQUID=21401281
local FUSION_MATERIAL_COUNT=2

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

	--① unaffected by opponent's "底噪石窟" effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.immval)
	c:RegisterEffect(e1)
	--① cannot be destroyed by battle with opponent's "底噪石窟"
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(s.indesval)
	c:RegisterEffect(e2)

	--② monsters in same column become "底噪石窟"
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.codetg)
	e3:SetValue(CARD_BOTTOMNOISE_CAVERN)
	c:RegisterEffect(e3)

	--② "底噪石" Fusion monsters can use opponent's "底噪石窟" as material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(CARD_EVIL_LIQUID)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
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
function s.immval(e,te)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return te:GetOwnerPlayer()~=c:GetControler()
		and tc:IsCode(CARD_BOTTOMNOISE_CAVERN)
end

function s.indesval(e,c)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-e:GetHandlerPlayer())
		and bc:IsCode(CARD_BOTTOMNOISE_CAVERN)
end

--② same column name change
function s.codetg(e,c)
	local hc=e:GetHandler()
	return c:IsFaceup() and s.incolumn(c,hc)
end

function s.incolumn(c,hc)
	if c==hc then return true end
	if Card.GetColumnGroup then
		return hc:GetColumnGroup():IsContains(c)
	end
	if not (c:IsLocation(LOCATION_MZONE) and hc:IsLocation(LOCATION_MZONE)) then return false end
	local seq=hc:GetSequence()
	if seq>4 then return false end
	if c:GetControler()==hc:GetControler() then
		return c:GetSequence()==seq
	else
		return c:GetSequence()==4-seq
	end
end
