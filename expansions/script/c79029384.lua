--东国·先锋干员-嵯峨
function c79029384.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCountLimit(1,79029384+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79029384.hspcon)
	e1:SetOperation(c79029384.hspop)
	c:RegisterEffect(e1)	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19029384)
	e2:SetTarget(c79029384.desreptg)
	e2:SetValue(c79029384.desrepval)
	e2:SetOperation(c79029384.desrepop)
	c:RegisterEffect(e2)  
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(79029384,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,09029384)
	e3:SetCost(c79029384.xyzcost)
	e3:SetTarget(c79029384.xyztg)
	e3:SetOperation(c79029384.xyzop)
	c:RegisterEffect(e3)
		if not c79029384.global_check then
		c79029384.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetCountLimit(1,79029384)
		ge1:SetCondition(c79029384.checkcon)
		ge1:SetOperation(c79029384.checkop)
		Duel.RegisterEffect(ge1,0)
end 
end
function c79029384.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xa900)
end
function c79029384.checkop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("让小僧来！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029384,5))
	local xp=re:GetHandlerPlayer()
	local flag=Duel.GetFlagEffectLabel(xp,79029384)
	if flag then
	Duel.SetFlagEffectLabel(xp,79029384,flag+1)
	else
	Duel.RegisterFlagEffect(xp,79029384,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c79029384.spfilter(c,ft)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and (ft>0 or c:GetSequence()<5) 
end
function c79029384.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c79029384.spfilter,tp,LOCATION_MZONE,0,1,nil,ft) and Duel.GetFlagEffect(tp,79029384)~=0 
end
function c79029384.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79029384.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Debug.Message("小僧来也！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029384,1))
end
function c79029384.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_ONFIELD) and not c:IsReason(REASON_REPLACE) and c:GetFlagEffect(79029384)==0
end
function c79029384.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79029384.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then 
	local g1=eg:Filter(c79029384.repfilter,nil,tp)
	Duel.HintSelection(g1)
	g1:KeepAlive()
	e:SetLabelObject(g1)
	local tc=g1:GetFirst()
	while tc do 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	tc:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetTarget(c79029384.potg)
	e4:SetOperation(c79029384.poop)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c79029384.tgtg)
	e5:SetOperation(c79029384.tgop)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e5)
	tc=g1:GetNext()
	end
	return true
	else
	return false 
	end
end
function c79029384.desrepval(e,c)
	return c79029384.repfilter(c,e:GetHandlerPlayer())
end
function c79029384.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,79029384)
	Debug.Message("住持爷爷说，要有慈悲之心，小僧也觉得差不多行了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029384,2))
	local g1=e:GetLabelObject()
	local tc=g1:GetFirst()
	while tc do
	tc:RegisterFlagEffect(79029384,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029384,0))
	tc=g1:GetNext()
	end
end
function c79029384.potg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029384.poop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("谁敢造次！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029384,3))
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c79029384.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029384.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_EFFECT+REASON_RULE)
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
end
function c79029384.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79029384.spfilter(c,e,tp)
	return c:IsCanBeXyzMaterial(nil)
end
function c79029384.fselect(g,tp,c)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c79029384.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) 
end
function c79029384.xyzfilter(c,g)
	return c:IsSetCard(0xa900) and c:IsXyzSummonable(g,2,2) and g:FilterCount(Card.IsCanBeXyzMaterial,nil,c)==g:GetCount()
end
function c79029384.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c79029384.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029384.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g1) and g1:CheckSubGroup(c79029384.fselect,2,2,tp,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029384.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c79029384.spfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	local g=Duel.GetMatchingGroup(c79029384.xyzfilter,tp,LOCATION_EXTRA,0,nil,g1)
	if g:GetCount()>0 then
	Debug.Message("小僧去也！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029384,4))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local sg=g1:SelectSubGroup(tp,c79029384.fselect,false,2,2,tp,e:GetHandler())
	Duel.XyzSummon(tp,tc,sg)
	end
end










