--天启录的灾星龙
function c21170040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21170040.mat,4,true)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170040,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21170040)
	e1:SetCondition(c21170040.con)
	e1:SetTarget(c21170040.tg)
	e1:SetOperation(c21170040.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c21170040.val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c21170040.con3)
	e3:SetTarget(c21170040.tg3)
	e3:SetOperation(c21170040.op3)
	c:RegisterEffect(e3)
	if not aux.apocalypse then
		aux.apocalypse=true
		apocalypse_IsCanBeFusionMaterial = Card.IsCanBeFusionMaterial
		Card.IsCanBeFusionMaterial = 
			function(card,fcard,...)
				if fcard and fcard:IsSetCard(0x6917) and card:IsPublic() and card:GetType()==TYPE_SPELL and card:IsSetCard(0x6917) then return true
				else 
					return apocalypse_IsCanBeFusionMaterial(card,fcard,...)
				end
			end
		apocalypse_GetFusionMaterial = Duel.GetFusionMaterial
		Duel.GetFusionMaterial =
			function(player,...)
				local exg=Duel.GetMatchingGroup(c21170040.mat2,player,LOCATION_HAND,0,nil)
				local fg=apocalypse_GetFusionMaterial(player,...)
				fg:Merge(exg)
				return fg
			end
			
	end	
end
function c21170040.mat(c)
	return c:IsSetCard(0x6917)
end
function c21170040.mat2(c)
	return c:IsPublic() and c:GetType()==TYPE_SPELL and c:IsSetCard(0x6917) and c:IsLocation(LOCATION_HAND)
end
function c21170040.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c21170040.q(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c21170040.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c21170040.q,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,4)>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c21170040.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21170040.q,tp,0,LOCATION_MZONE,nil)
	local s=Duel.GetLocationCount(tp,4)
	if s<=0 then return end
	local min=math.min(s,#g)
	if min>3 then min=3 end
	Duel.Hint(3,tp,HINTMSG_CONTROL)
	local sg=Duel.SelectMatchingCard(tp,c21170040.q,tp,0,LOCATION_MZONE,1,min,nil)
	Duel.HintSelection(sg)
	Duel.GetControl(sg,tp)
	local og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c21170040.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	tc:RegisterEffect(e1,true)
	end
end
function c21170040.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=c:GetOwner() then
	Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c21170040.val(e,c)
	return c:IsFaceup() and c:IsSetCard(0x6917)
end
function c21170040.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c21170040.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c21170040.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SendtoGrave(c,REASON_EFFECT)
	end
end