--夜刀神十香 校服
function c33400306.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	 --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33400306.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c33400306.indcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400306,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetTarget(c33400306.drtg)
	e3:SetOperation(c33400306.drop)
	c:RegisterEffect(e3)
	--to hand from grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400306,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c33400306.indcon2)
	e4:SetTarget(c33400306.adtg)
	e4:SetOperation(c33400306.adop)
	c:RegisterEffect(e4)
end
function c33400306.mfilter(c)
	return not c:IsType(TYPE_RITUAL)
end
function c33400306.indcon(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return  c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 and not mg:IsExists(c33400306.mfilter,1,nil)
end
function c33400306.indcon2(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 and not mg:IsExists(c33400306.mfilter,1,nil)
end
function c33400306.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c33400306.costfilter(c)
	return c:IsSetCard(0x5341) and c:IsDiscardable()
end
function c33400306.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c33400306.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	Duel.SetTargetParam(2)
	if c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 and not mg:IsExists(c33400306.mfilter,1,nil)  then 
	Duel.SetTargetParam(3)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33400306.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,c33400306.costfilter,1,1,REASON_DISCARD)	
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c33400306.thfilter1(c)
	return c:IsType(0x82) and c:IsAbleToHand() 
end
function c33400306.thfilter2(c)
	return c:IsType(0x81) and c:IsAbleToHand() 
end
function c33400306.thfilter3(c)
	return c:IsType(0x80) and c:IsAbleToHand() 
end
function c33400306.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400306.thfilter3,tp,LOCATION_GRAVE,0,1,nil)	
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c33400306.adop(e,tp,eg,ep,ev,re,r,rp)   
	local g1=Duel.GetMatchingGroup(c33400306.thfilter3,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=g1:SelectSubGroup(tp,c33400306.check,false,1,2) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end   
end
function c33400306.check(g,c)
	if #g==1 then return true end
	local res=0
	if #g==2 then 
	if g:IsExists(c33400306.thfilter1,1,nil,c) then res=res+1 end
	if g:IsExists(c33400306.thfilter2,1,nil,c) then res=res+4 end
	return res==5 
	end
end