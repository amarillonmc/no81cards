--天灾信使·辅助干员-地灵
function c79029098.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029098.lzcon)
	e1:SetTarget(c79029098.lztg)
	e1:SetOperation(c79029098.lzop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c79029098.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetOperation(c79029098.efop)
	c:RegisterEffect(e4)	 
end
function c79029098.mfilter(c)
	return not c:IsType(TYPE_SYNCHRO)
end
function c79029098.valcheck(e,c)
	local mg=c:GetMaterial()
	if not mg:IsExists(c79029098.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c79029098.lzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c79029098.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c79029098.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029098.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c79029098.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c79029098.lzop(e,tp,eg,ep,ev,re,r,rp)
		local g2=Duel.GetMatchingGroup(c79029098.posfilter,tp,0,LOCATION_MZONE,nil)
		if g2:GetCount()>0 then
			Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
		end
end
function c79029098.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return ec:IsSetCard(0xa900)
end
function c79029098.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029098)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--to grave
	local e4=Effect.CreateEffect(rc)
	e4:SetDescription(aux.Stringid(18940556,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c79029098.tgtg)
	e4:SetOperation(c79029098.tgop)
	rc:RegisterEffect(e4)
end
function c79029098.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function c79029098.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,1000,REASON_EFFECT)~=0 then
		local d=Duel.GetAttackTarget()
		if d:IsRelateToBattle() and d:IsDefensePos() then
			Duel.SendtoGrave(d,REASON_EFFECT)
		end
	end
end












