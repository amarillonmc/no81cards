--阿戈尔·辅助干员-浊心斯卡蒂
function c79029468.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcCodeFunRep(c,79029010,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),2,99,true,true)  
	--cannot target
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(aux.indoval)
	c:RegisterEffect(e0)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029468,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029468.chain_target)
	e1:SetOperation(c79029468.chain_operation)
	e1:SetValue(aux.FilterBoolFunction(Card.IsCode,79029468))
	c:RegisterEffect(e1) 
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c79029468.rctg)
	e2:SetOperation(c79029468.rcop)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c79029468.akval)
	c:RegisterEffect(e3)
	--Def
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(c79029468.tgtg) 
	e5:SetOperation(c79029468.tgop)
	c:RegisterEffect(e5)
end
function c79029468.chain_target(e,te,tp)
	return Duel.GetMatchingGroup(c79029468.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,te)
end
function c79029468.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Debug.Message("我已经不再是独自行走了。我的血亲在我身侧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029469,0))
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
end
function c79029468.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetHandler():GetMaterialCount()>0 end
	local x=e:GetHandler():GetMaterialCount()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,x*1000)
end
function c79029468.rcop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("那么，就请听听这远海的歌吧......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029469,1))
	local p,d=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c79029468.akval(e,c)
	return e:GetHandler():GetMaterialCount()*1000
end
function c79029468.tgfil(c)
	return c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c79029468.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029468.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,0)
end
function c79029468.tgop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("随我走吧，随我回去我们永恒的故乡。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029469,2))
	local g=Duel.GetMatchingGroup(c79029468.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	local x=Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
	if x>0 then 
	Duel.Recover(tp,x*1500,REASON_EFFECT)
	end
end






