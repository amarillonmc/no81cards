local m=188862
local cm=_G["c"..m]
cm.name="血钻魅影-傀影"
function cm.initial_effect(c)
	aux.AddCodeList(c,m-1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(m-1)
	c:RegisterEffect(e0)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,c)return Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)*300 end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,m-1)end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,m-1) and ep~=tp end)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,m-1) and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) end)
	c:RegisterEffect(e4)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,3300,1600,8,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.sumfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and _G["c"..c:GetCode()].named_with_Arknight)) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,3300,1600,8,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,m+1)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil) or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then Duel.Summon(tp,tc,true,nil) else
			Duel.ConfirmCards(1-tp,tc)
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
