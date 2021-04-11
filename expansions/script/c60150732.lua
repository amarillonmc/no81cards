--正妻的从容 纯白型君士坦丁
function c60150732.initial_effect(c)
	c:SetUniqueOnField(1,0,60150732)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,60150722,60150798,true,true)
	--cannot fusion material
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60150732.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60150732.spcon)
	e2:SetOperation(c60150732.spop)
	c:RegisterEffect(e2)
	--2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150732,2))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,60150732)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e3:SetTarget(c60150732.distg)
	e3:SetOperation(c60150732.disop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c60150732.tglimit)
	c:RegisterEffect(e4)
end
function c60150732.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150732.spfilter1(c,tp,fc)
	return c:IsCode(60150722) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c60150732.spfilter2,tp,LOCATION_ONFIELD,0,1,c,fc)
end
function c60150732.spfilter2(c,fc)
	return c:IsCode(60150798) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
end
function c60150732.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if (c1 and c1:IsCode(60150798)) or (c2 and c2:IsCode(60150798)) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c60150732.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60150732.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
	end
end
function c60150732.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150732,0))
		local g1=Duel.SelectMatchingCard(tp,c60150732.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150732,1))
		local g2=Duel.SelectMatchingCard(tp,c60150732.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150732,0))
		local g1=Duel.SelectMatchingCard(tp,c60150732.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150732,1))
		local g2=Duel.SelectMatchingCard(tp,c60150732.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	end
end
function c60150732.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c60150732.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150732.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c60150732.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	local def=g:GetFirst():GetDefense()
	local rec=(atk+def)/2
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c60150732.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150732,5))
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150732,4))
			local op=Duel.SelectOption(tp,aux.Stringid(60150732,2),aux.Stringid(60150732,3))
			if op==0 then
				Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
				Duel.Recover(p,d,REASON_EFFECT)
			else
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
				Duel.Recover(p,d,REASON_EFFECT)
			end
		end
	end
end
function c60150732.tglimit(e,c)
	local def=e:GetHandler():GetDefense()
	return c:GetAttack()<def
end
