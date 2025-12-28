--「02的一击」
local m=64830511
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,64830500)

	local f1=function(rc)
		return rc:IsFacedown() or not rc:IsCode(64830500)
	end
	local f2=function(e,tp)
		return not Duel.IsExistingMatchingCard(f1,tp,LOCATION_MZONE,0,1,nil)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(f2)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=aux.SelectTargetFromFieldFirst(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.limit(g:GetFirst()))
	end
end
function cm.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function cm.op(e,tp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	local atk=tc:GetAttack()/2
	Duel.Damage(tp,atk,REASON_EFFECT)
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	if Duel.GetLP(tp)==0 or Duel.GetLP(1-tp)==0 then return end
	local f=function(c2,e2,tp2)
		return c2:IsCode(64830500) and c2:IsCanBeSpecialSummoned(e2,0,tp2,false,false)
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,f,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
