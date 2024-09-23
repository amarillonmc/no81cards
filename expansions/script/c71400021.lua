--幻异梦像-菜刀
if not c71400001 then dofile("expansions/script/c71400001.lua") end
function c71400021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMING_SPSUMMON+TIMING_SUMMON,0)
	e1:SetCountLimit(1,71400021+EFFECT_COUNT_CODE_OATH)
	e1:SetDescription(aux.Stringid(71400021,0))
	e1:SetTarget(c71400021.target)
	e1:SetCondition(yume.YumeCon)
	e1:SetOperation(c71400021.operation)
	c:RegisterEffect(e1)
	yume.AddYumeWeaponGlobal(c)
end
function c71400021.filter1des(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c71400021.filter1pos,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c71400021.filter1pos(c)
	return c:IsSetCard(0x714) and c:IsCanTurnSet() and c:IsFaceup()
end
function c71400021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c and c71400021.filter1des(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c71400021.filter1des,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c71400021.filter1des,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,tp)
	local tc=g:GetFirst()
	local sg=Duel.GetMatchingGroup(c71400021.filter1pos,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),tp,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c71400021.limit(tc))
	end
end
function c71400021.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local sg=Duel.GetMatchingGroup(c71400021.filter1pos,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c71400021.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end