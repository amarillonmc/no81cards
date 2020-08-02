--罗德岛·狙击干员-克洛斯
function c79029107.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(c79029107.reop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c79029107.sptg)
	e2:SetOperation(c79029107.spop)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_CANNOT_DISABLE)
	e3:SetTarget(c79029107.target1)
	e3:SetOperation(c79029107.operation1)
	c:RegisterEffect(e3)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_CANNOT_DISABLE)
	e3:SetTarget(c79029107.target1)
	e3:SetOperation(c79029107.operation1)
	c:RegisterEffect(e3)
end
function c79029107.reop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	if e:GetHandler():GetFlagEffect(79029107)~=0 then return end
	Duel.SendtoDeck(e:GetHandler(),1-p,2,REASON_EFFECT)
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
	Duel.Draw(tp,1,REASON_EFFECT)
	end  
	e:GetHandler():RegisterFlagEffect(79029107,0,0,0)
	if Duel.GetFlagEffect(tp,79029107)==0 then 
	Debug.Message("你在这里~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029107,0)) 
	Duel.RegisterFlagEffect(tp,79029107,0,0,0)
end   
end
function c79029107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c79029107.spop(e,tp,eg,ep,ev,re,r,rp)
	local h=e:GetHandler():GetOwner()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.SendtoDeck(e:GetHandler(),1-h,2,REASON_EFFECT)
	Debug.Message("在~这~里~哦")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029107,1))   
end
function c79029107.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c79029107.operation1(e,tp,eg,ep,ev,re,r,rp)
	local h=e:GetHandler():GetOwner()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.SendtoDeck(e:GetHandler(),1-h,2,REASON_EFFECT)
	Debug.Message("在~这~里~哦")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029107,1))   
end

