--天启录的蚀星虺
function c21170045.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21170045.mat,4,true)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170045,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,21170045)
	e1:SetTarget(c21170045.tg)
	e1:SetOperation(c21170045.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c21170045.con2)
	e2:SetTarget(c21170045.tg2)
	e2:SetOperation(c21170045.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c21170045.tg3)
	e3:SetOperation(c21170045.op3)
	e3:SetValue(c21170045.val3)
	c:RegisterEffect(e3)
	if not aux.apocalypse then
		aux.apocalypse=true
		apocalypse_IsCanBeFusionMaterial = Card.IsCanBeFusionMaterial
		Card.IsCanBeFusionMaterial = 
			function(card,fcard,...)
				if fcard and fcard:IsSetCard(0x6907) and card:IsPublic() and card:GetType()==TYPE_SPELL and card:IsSetCard(0x6907) then return true
				else 
					return apocalypse_IsCanBeFusionMaterial(card,fcard,...)
				end
			end
		apocalypse_GetFusionMaterial = Duel.GetFusionMaterial
		Duel.GetFusionMaterial =
			function(player,...)
				local exg=Duel.GetMatchingGroup(c21170045.mat2,player,LOCATION_HAND,0,nil)
				local fg=apocalypse_GetFusionMaterial(player,...)
				fg:Merge(exg)
				return fg
			end
			
	end	
end
function c21170045.mat(c)
	return c:IsSetCard(0x6907)
end
function c21170045.mat2(c)
	return c:IsPublic() and c:GetType()==TYPE_SPELL and c:IsSetCard(0x6907) and c:IsLocation(LOCATION_HAND)
end
function c21170045.q(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsType(1)
end
function c21170045.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21170045.q,tp,0,LOCATION_GRAVE+4,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(3,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c21170045.q,tp,0,LOCATION_GRAVE+4,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c21170045.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() and c:IsLocation(4) or not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if not Duel.Equip(tp,tc,c) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(0x1002000)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c21170045.eqlimit)
	tc:RegisterEffect(e1,true)
	local atk=tc:GetBaseAttack()
	if atk>0 then
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(0x1000000+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(math.ceil(atk/2))
	tc:RegisterEffect(e2,true)
	end
end
function c21170045.eqlimit(e,c)
	return c==e:GetOwner()
end
function c21170045.con2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsSetCard(0x6907) and at~=e:GetHandler()
end
function c21170045.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c21170045.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Damage(1-tp,800,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end
end
function c21170045.rep(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6907) and c:IsLocation(4) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c21170045.rep2(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c21170045.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if chk==0 then return eg:IsExists(c21170045.rep,1,nil,tp) and g:IsExists(c21170045.rep2,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c21170045.val3(e,c)
	return c21170045.rep(c,e:GetHandlerPlayer())
end
function c21170045.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,c21170045.rep2,1,1,nil)
	if #sg>0 then
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REPLACE)
	end
end