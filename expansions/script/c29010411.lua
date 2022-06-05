--束缚之心罪·傲狮之半梦魇
function c29010411.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()   
	--xyz 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_CHAINING) 
	e0:SetRange(LOCATION_EXTRA) 
	e0:SetCondition(c29010411.xyzcon) 
	e0:SetOperation(c29010411.xyzop) 
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010411,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c29010411.drcon)
	e1:SetCost(c29010411.drcost)
	e1:SetTarget(c29010411.drtg)
	e1:SetOperation(c29010411.drop)
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29010411.imcon)
	e2:SetValue(c29010411.efilter)
	c:RegisterEffect(e2)
end
function c29010411.xyzcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local rc=re:GetOwner() 
	local ph=Duel.GetCurrentPhase() 
	local g=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE,0,nil,c):Filter(Card.IsXyzLevel,nil,c,4)
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetFlagEffect(tp,29010411)==0 and rc:IsSetCard(0x7a1) and rp==tp and g:GetCount()>=2 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)  
end 
function c29010411.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.GetFlagEffect(tp,29010411)~=0 then return end 
	if Duel.SelectYesNo(tp,aux.Stringid(29010411,0)) then 
	Duel.RegisterFlagEffect(tp,29010411,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE,0,nil,c):Filter(Card.IsXyzLevel,nil,c,4) 
	local mg=g:Select(tp,2,2,nil) 
	Duel.Overlay(c,mg) 
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end 
end 
function c29010411.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end 
function c29010411.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c29010411.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29010411.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c29010411.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
function c29010411.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end


