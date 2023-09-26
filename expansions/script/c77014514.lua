--反转体 恶魔-救世魔王
function c77014514.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77014514.splimit)
	c:RegisterEffect(e1)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7969770,0)) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c77014514.mvtg)
	e1:SetOperation(c77014514.mvop)
	c:RegisterEffect(e1) 
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c77014514.damcon)
	e2:SetTarget(c77014514.damtg)
	e2:SetOperation(c77014514.damop)
	c:RegisterEffect(e2) 
	--to deck and recover 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_REMOVED) 
	e3:SetCondition(c77014514.tdrcon)
	e3:SetTarget(c77014514.tdrtg)
	e3:SetOperation(c77014514.tdrop)
	c:RegisterEffect(e3)
end 
function c77014514.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(77000528)
end
function c77014514.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return e:GetHandler():GetFlagEffect(77014514)==0 and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77014514,1))
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77014514.mvop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq) 
	local rg=tc:GetColumnGroup():Filter(Card.IsAbleToRemove,nil) 
	if rg:GetCount()>0 then 
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end 
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(77014514,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function c77014514.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77014514.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,PLAYER_ALL,1000)
end
function c77014514.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Damage(tp,d,REASON_EFFECT)
	Duel.Damage(1-tp,d,REASON_EFFECT)
end 
function c77014514.ckfil(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT) 
end
function c77014514.tdrcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c77014514.ckfil,1,nil)   
end 
function c77014514.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToExtra() end 
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0) 
end 
function c77014514.tdrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and g:GetCount()>0 then 
	Duel.BreakEffect()
	Duel.Recover(tp,g:GetCount()*100,REASON_EFFECT) 
	Duel.Recover(1-tp,g:GetCount()*100,REASON_EFFECT) 
	end  
end 






