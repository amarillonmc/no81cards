--
local s,id=GetID()
function c99108870.initial_effect(c)

	-- 同调属性设置
	c:EnableReviveLimit()
	-- 同调条件
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	
	-- 效果①：相剑素材同调召唤时获得抗性和ATK提升
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(s.imcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.atkcon)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	
	-- 效果②：特召衍生物和墓地相剑怪兽进行加速同调
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	
	-- 效果③：相剑怪兽攻击时除外对方卡
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.rmcon)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end

-- 效果①条件：使用相剑怪兽作为素材同调召唤
function s.imcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
		and e:GetHandler():GetMaterial():IsExists(Card.IsSetCard,1,nil,0x16b)
end

function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

-- 效果①ATK提升计算
function s.atkcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end

function s.atkfilter(c)
	return c:IsType(TYPE_MONSTER) 
end

function s.atkval(e,c)
	local g=e:GetHandler():GetMaterial():Filter(s.atkfilter,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function s.chkfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x16b) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.fselect(g,tp,token)
	g:AddCard(token)
	return  Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.synfilter(c,g)
	return c:IsSetCard(0x16b) and c:IsSynchroSummonable(nil,g)
end
-- 效果②目标选择
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return false end
		local cg=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
	return  Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER,0,0,4,RACE_WYRM,ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x16b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果②操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_WYRM,ATTRIBUTE_WATER) then
	local cg=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local token=Duel.CreateToken(tp,20001444)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		if #cg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			--local sg=g:SelectSubGroup(tp,s.fselect,false,1,1,tp,token)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)			
			Duel.SpecialSummonStep(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				sg:GetFirst():RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
				Duel.AdjustAll()	   
				local og=Group.CreateGroup()
				og:AddCard(sg:GetFirst())
				og:AddCard(token)
				local tg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,og)
				if  tg:GetCount()>0  then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local rg=tg:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
				-- 同调召唤的怪兽获得效果抗性
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(id,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(s.immval)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				rg:GetFirst():RegisterEffect(e1)
		   end
		end
	end
end


function s.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- 效果③条件：相剑怪兽攻击宣言
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetAttacker()
	local tc2=Duel.GetAttackTarget()
	if tc2~=nil then return tc1:IsSetCard(0x16b) or tc2:IsSetCard(0x16b) end
	return  tc1:IsSetCard(0x16b) 
end

-- 效果③目标选择
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end

-- 效果③操作
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

