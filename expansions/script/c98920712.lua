--归魂复仇死者·裁决侠
function c98920712.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c98920712.matfilter,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),1,1,true)
	aux.AddContactFusionProcedure(c,c98920712.cfilter,LOCATION_MZONE,LOCATION_MZONE,c98920712.sprop(c))
	--code
	aux.EnableChangeCode(c,4388680)
	--spsummon1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920712,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c98920712.sptg1)
	e2:SetOperation(c98920712.spop1)
	c:RegisterEffect(e2)
	--lock
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98920712,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c98920712.tdcon)
	e6:SetTarget(c98920712.tdtg)
	e6:SetOperation(c98920712.tdop)
	c:RegisterEffect(e6)
end
function c98920712.matfilter(c,fc)
	return c:IsOriginalCodeRule(4388680) and c:IsOnField() and c:IsControler(fc:GetControler())
end
function c98920712.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c98920712.cfilter(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function c98920712.sprop(c)
	return	function(g)
				Duel.SendtoGrave(g,REASON_COST)
			end
end
function c98920712.spfilter1(c,e,tp)
	return c:IsSetCard(0x106) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920712.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		and Duel.IsExistingMatchingCard(c98920712.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c98920712.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if ft>0 and ct>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		ct=math.min(ct,ft)
		local g=Duel.GetMatchingGroup(c98920712.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98920712.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c98920712.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98920712.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if tp==Duel.GetTurnPlayer() then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	   e1:SetCode(EFFECT_CANNOT_SUMMON)
	   e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	   e1:SetTargetRange(1,0)
	   Duel.RegisterEffect(e1,tp)
	   local e2=Effect.CreateEffect(e:GetHandler())
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	   e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	   e2:SetTargetRange(1,0)
	   Duel.RegisterEffect(e2,tp)
	else
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	   e1:SetCode(EFFECT_CANNOT_SUMMON)
	   e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	   e1:SetTargetRange(0,1)
	   Duel.RegisterEffect(e1,tp)
	   local e2=Effect.CreateEffect(e:GetHandler())
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	   e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	   e2:SetTargetRange(0,1)
	   Duel.RegisterEffect(e2,tp)
	 end
end