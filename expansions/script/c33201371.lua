--唤祐重器 天亡簋
local s,id,o=GetID()
Duel.LoadScript("c33201370.lua")
function s.initial_effect(c)
	VHisc_HYZQ.rlef(c,id,0x1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.VHisc_HYZQ=true
s.VHisc_CNTreasure=true


function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) and VHisc_HYZQ.mck(tp,id) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local ct=Duel.SendtoGrave(g,REASON_RELEASE)
	VHisc_HYZQ.mop(e,tp,m)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.ft,tp,LOCATION_DECK,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.ft,tp,LOCATION_DECK,0,1,1,nil)
		local sc=sg:GetFirst()
		sc:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function s.ft(c)
	return c.VHisc_HYZQ and c:IsType(TYPE_SPELL) and not c:IsCode(33201371) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,1500,1500,4,RACE_ROCK,ATTRIBUTE_EARTH)
end

--Release effect
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end