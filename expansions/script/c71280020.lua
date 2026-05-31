--魔法卡「升阶魔法-千死蛮巧」
function c71280020.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,71280020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71280020.target)
	e1:SetOperation(c71280020.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetLabelObject(e0)
	e2:SetCondition(c71280020.con)
	e2:SetOperation(c71280020.op)
	c:RegisterEffect(e2)
end
function c71280020.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ) and c:IsCanOverlay() and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c71280020.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk+1)
end
function c71280020.spfilter(c,e,tp,rk)
	return c:IsRank(rk) and c:IsSetCard(0x1048,0x1073) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c71280020.gcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c71280020.fselect(g,e,tp)
	local mg=Duel.GetMatchingGroup(c71280020.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,9)
	return not g:GetFirst():IsRank(8)
		or mg:IsExists(aux.NOT(Card.IsOriginalCodeRule),1,nil,6165656) or g:IsExists(Card.IsCode,1,nil,48995978)
		and (g:IsExists(Card.IsControler,1,nil,tp) or g:IsExists(Card.IsControler,1,nil,1-tp))
end
function c71280020.spfilter2(c,e,tp,rk,tg)
	return c71280020.spfilter(c,e,tp,rk) and (not c:IsOriginalCodeRule(6165656) or tg:IsExists(Card.IsCode,1,nil,48995978))
end
function c71280020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c71280020.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return false end
	if chk==0 then
		aux.GCheckAdditional=c71280020.gcheck
		local res=g:CheckSubGroup(c71280020.fselect,1,#g,e,tp)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	aux.GCheckAdditional=c71280020.gcheck
	local g1=g:SelectSubGroup(tp,c71280020.fselect,false,1,#g,e,tp)
	aux.GCheckAdditional=nil
	Duel.SetTargetCard(g1)
	local rk=g1:GetFirst():GetRank()
	e:SetLabel(rk)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c71280020.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rk=e:GetLabel()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71280020.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk+1,tg)
	local sc=g:GetFirst()
	if sc then
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c71280020.indes)
		sc:RegisterEffect(e2)
		e:GetHandler():RegisterFlagEffect(71280020,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71280020,2))
		Debug.Message('锵✩锵✩锵！！！')
		Debug.Message('这可是现在才曝光的冲击性事实！！！')
	end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c71280020.indes(e,c)
	return not c:IsType(TYPE_XYZ)
end
function c71280020.cfilter(c,tp,se)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and c:IsSetCard(0x1048)
		and (se==nil or c:GetReasonEffect()~=se)
end
function c71280020.con(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c71280020.cfilter,1,nil,tp,se) and Duel.GetFlagEffect(tp,71280020)==0
end
function c71280020.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	Duel.RegisterFlagEffect(tp,71280020,0,0,0)
end