--幸运满贯 主唱Go-Spell
local s,id,o=GetID()
function s.initial_effect(c)
	--①：召唤·特殊召唤时，抽1，有其他「幸运满贯」怪兽再回复1600
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	--②：有其他「幸运满贯」怪兽存在，当作调整
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.tncon)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
	--③：怪兽效果发动时，衍生物+同调
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end
--① target
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--① operation
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	if Duel.IsExistingMatchingCard(s.tnfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then
		Duel.Recover(tp,1600,REASON_EFFECT)
	end
end
--② condition
function s.tncon(e)
	return Duel.IsExistingMatchingCard(s.tnfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.tnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x892) and c:IsType(TYPE_MONSTER)
end
--③ condition
function s.e3con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc and re:IsActiveType(TYPE_MONSTER) and rc~=c
end
--③ target
function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x892,TYPES_TOKEN_MONSTER,0,1600,1,RACE_SPELLCASTER,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
--③ operation
function s.synfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil)
end
function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x892,TYPES_TOKEN_MONSTER,0,1600,1,RACE_SPELLCASTER,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,id+1)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then return end
	if not Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.synfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end