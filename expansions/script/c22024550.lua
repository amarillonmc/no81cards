--吾等之臂开拓一切，至天际
function c22024550.initial_effect(c)
	aux.AddCodeList(c,22024540)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--coin result
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024550,0))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(7,22024550)
	e2:SetCondition(c22024550.coincon1)
	e2:SetTarget(c22024550.tg)
	e2:SetOperation(c22024550.coinop1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024550,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22024551)
	e3:SetCondition(c22024550.spcon)
	e3:SetTarget(c22024550.sptg)
	e3:SetOperation(c22024550.spop)
	c:RegisterEffect(e3)
	if not c22024550.global_flag then
		c22024550.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c22024550.regop1)
		Duel.RegisterEffect(ge1,0)
	end
end
c22024550.toss_coin=true
function c22024550.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 then
		e:SetLabelObject(re)
		return true
	else return false end
end
function c22024550.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22024550)==0 and Duel.IsPlayerCanDraw(tp,1) end
	c:RegisterFlagEffect(22024550,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,2)
end
function c22024550.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c1,c2=Duel.TossCoin(tp,2)
	if c1+c2==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c22024550.regop1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 then
			Duel.RegisterFlagEffect(tp,22024550,RESET_PHASE+PHASE_END,0,1)
	end
end

function c22024550.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22024550)>6
end
function c22024550.spfilter(c,e,tp)
	return c:IsCode(22024540) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22024550.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c22024550.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22024550.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22024550.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
