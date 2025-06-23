-- 龗龘场地魔法
local s,id=GetID()

function s.initial_effect(c)
	-- 场地魔法特性
	
	-- 效果①：发动时检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- 效果②：龗龘卡离场时特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e10=e2:Clone()
	e10:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e10)
	local e11=e2:Clone()
	e11:SetCode(EVENT_DESTROY)
	c:RegisterEffect(e11)
	local e12=e2:Clone()	
	e12:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e12)  
	-- 效果③：召唤/特召时回复+伤害
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.damcon)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
	-- 限制场地魔法发动
end

-- 效果①目标：检索龗龘卡
function s.thfilter(c)
	return c:IsSetCard(0x5450) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果①操作：检索龗龘卡
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	local c=e:GetHandler()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(1,0)
	e5:SetValue(s.aclimit)
	Duel.RegisterEffect(e5,tp)
	end
end

-- 效果②条件：龗龘卡被送墓/除外/破坏/解放
function s.cfilter(c,tp)
	return c:IsSetCard(0x5450) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

-- 效果②目标：特殊召唤
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=s.fufilter(e,tp)
	if chk==0 then return b1 or b2 or b3 or b4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x5450)
end
function s.sfilter(c)
	return c:IsSynchroSummonable(nil)and c:IsSetCard(0x5450)
end
function s.lfilter(c)
	return c:IsLinkSummonable(nil)and c:IsSetCard(0x5450)
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x5450)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fufilter(e,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
end
-- 效果③操作：进行特殊召唤
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=s.fufilter(e,tp)
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(id,3)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(id,4)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(id,5)
				opval[off-1]=3
				off=off+1
			end
			 if b4 then
				ops[off]=aux.Stringid(id,6)
				opval[off-1]=4
				off=off+1
			end  
			local op=Duel.SelectOption(tp,table.unpack(ops)) 
			if opval[op]==1 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SynchroSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.XyzSummon(tp,g:GetFirst(),nil)
			elseif opval[op]==3 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.LinkSummon(tp,g:GetFirst(),nil)
			else 
				local chkf=tp
				local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e):Filter(Card.IsLocation,nil,LOCATION_MZONE)
				local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
				local mg2=nil
				local sg2=nil
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
				end
				if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					else
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
				end
			end
	
end

function s.fitn(c)
	return c:IsSetCard(0x5450) and c:IsFaceup()
end
-- 效果③条件：场上有龗龘怪兽
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.fitn,tp,LOCATION_MZONE,0,1,nil)
end

-- 效果③操作：回复+伤害
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,100,REASON_EFFECT)
	Duel.Damage(1-tp,100,REASON_EFFECT)
end

-- 限制场地魔法发动
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and not re:GetHandler():IsSetCard(0x5450)
end
