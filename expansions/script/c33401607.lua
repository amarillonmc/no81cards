--无言之观测者 万由里
local m=33401607
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
XY.mayuri(c)
	  --fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
 --
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.con)
	e7:SetTarget(cm.thtg)
	e7:SetOperation(cm.thop)
	c:RegisterEffect(e7)
	local e9=e7:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_RELEASE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(cm.thtg)
	e8:SetOperation(cm.thop)
	c:RegisterEffect(e8)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) and c:IsFusionSetCard(0x341)
end

function cm.cckfilter(c,at)
	return   c:IsFaceup() and c:GetAttribute()&at~=0
end
function cm.cfilter(c,tp)
	return  c:IsFaceup() and c:IsSetCard(0x6344) and c:IsControler(tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.thfilter1(c)
	return  c:IsSetCard(0x6344) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.cckfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttribute())  and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()	 
	if  Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local tc=g:GetFirst()
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_HAND)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(cm.thlimit)
			e0:SetLabel(tc:GetAttribute())
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function cm.thlimit(e,c,tp,re)
	return c:GetAttribute()&e:GetLabel()~=0 and re and re:GetHandler():IsCode(m)
end