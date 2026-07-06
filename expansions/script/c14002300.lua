--幻梦乡的第二王女 夜刀浦罗
local m=14002300
local cm=_G["c"..m]
if not UraraG then
	UraraG=UraraG or {}
	UraraG.fieldcheck_counter = UraraG.fieldcheck_counter or {}
	UraraG.fieldcheck_release = UraraG.fieldcheck_release or {}
	if not UraraG.fieldcheck_reg then
		UraraG.fieldcheck_reg = true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(function()
			for p=0,1 do
				local fc_rel=UraraG.fieldcheck_release[p]
				if not fc_rel or type(fc_rel)~="userdata" or fc_rel:IsHasEffect(14002341)==nil or fc_rel:GetFlagEffect(14002341)>0 then
					local g1=Duel.GetMatchingGroup(function(c) return c:IsHasEffect(14002341)~=nil and c:GetFlagEffect(14002341)==0 end,p,LOCATION_ONFIELD,0,nil)
					UraraG.fieldcheck_release[p]=g1:GetFirst() or nil
				end
				local fc_ct=UraraG.fieldcheck_counter[p]
				if not fc_ct or type(fc_ct)~="userdata" or fc_ct:IsHasEffect(14002342)==nil or fc_ct:GetFlagEffect(14002342)>0 then
					local g2 = Duel.GetMatchingGroup(function(c) return c:IsHasEffect(14002342)~=nil and c:GetFlagEffect(14002342)==0 end, p, LOCATION_ONFIELD, 0, nil)
					UraraG.fieldcheck_counter[p] = g2:GetFirst() or nil
				end
			end
		end)
		Duel.RegisterEffect(ge1, 0)
	end
	function UraraG.Hastur(c)
		local m_code=_G["c"..c:GetCode()]
		return m_code and m_code.named_with_Hastur
	end
	function UraraG.Urara(c)
		local m_code=_G["c"..c:GetCode()]
		return m_code and m_code.named_with_Urara
	end
	function UraraG.get_available_field(tp,code)
		if not UraraG then return nil end
		local c = nil
		if code == 14002341 and UraraG.fieldcheck_release then
			c = UraraG.fieldcheck_release[tp]
		elseif code == 14002342 and UraraG.fieldcheck_counter then
			c = UraraG.fieldcheck_counter[tp]
		end
		if c and type(c)=="userdata" and c:IsHasEffect(code)~=nil and c:GetFlagEffect(code)==0 then
			return c
		end
		return nil
	end
	function UraraG.HasturSpecialProEffect1(c,con,tg,op,hdgy)
		local code=c:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(code,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		if hdgy then
			e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
		else
			e1:SetRange(LOCATION_HAND)
		end
		e1:SetCondition(con)
		e1:SetTarget(tg)
		e1:SetOperation(op)
		e1:SetValue(SUMMON_VALUE_SELF)
		c:RegisterEffect(e1)
	end
	function UraraG.HasturSpecialSucEffect1(c,cate,tg,op)
		local code=c:GetOriginalCodeRule()
		local ccode=_G["c"..code]
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,1))
		if cate then
			e2:SetCategory(cate)
		end
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCost(UraraG.cost)
		if tg then
			e2:SetTarget(tg)
		end
		e2:SetOperation(op)
		c:RegisterEffect(e2)
		ccode.selfsummon_effect=e2
	end
	function UraraG.HasturRepTokenEffect(c)
		local code=c:GetOriginalCodeRule()
		--token
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EFFECT_SEND_REPLACE)
		e3:SetRange(0xff)
		e3:SetTarget(UraraG.reptg)
		e3:SetValue(UraraG.repval)
		c:RegisterEffect(e3)
	end
	function UraraG.linkexmat(c,matval)
		local code=c:GetOriginalCodeRule()
		--link
		c:EnableReviveLimit()
		aux.AddLinkProcedure(c,nil,3,99,UraraG.lcheck)
		--exlink mat
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e0:SetRange(LOCATION_EXTRA)
		e0:SetTargetRange(0,LOCATION_MZONE)
		--e0:SetValue(UraraG.matval)
		e0:SetValue(matval)
		c:RegisterEffect(e0)
	end
	function UraraG.synexmat(c,tunerf)
		local code=c:GetOriginalCodeRule()
		--Synchro
		c:EnableReviveLimit()
		if tunerf then
			aux.AddSynchroMixProcedure(c,aux.Tuner(tunerf),nil,nil,UraraG.synmatfilter,1,99)
		else
			aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,UraraG.synmatfilter,1,99)
		end
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(code,0))
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_SPSUMMON_PROC)
		e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetRange(LOCATION_EXTRA)
		e0:SetCondition(UraraG.stsyncon)
		e0:SetTarget(UraraG.stsyntg)
		e0:SetOperation(UraraG.stsynop)
		e0:SetValue(SUMMON_TYPE_SYNCHRO)
		c:RegisterEffect(e0)
	end
	function UraraG.atkchange(c)
		local code=c:GetOriginalCodeRule()
		--atkchange
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(UraraG.atkcon)
		e1:SetTarget(UraraG.atktg)
		e1:SetOperation(UraraG.atkop)
		c:RegisterEffect(e1)
	end
	function UraraG.token1(c)
		local code=c:GetOriginalCodeRule()
		--spsummon token
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,0))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e2:SetCountLimit(2,code)
		e2:SetCost(UraraG.spcost)
		e2:SetTarget(UraraG.sptg)
		e2:SetOperation(UraraG.spop)
		e2:SetLabel(14002381)
		c:RegisterEffect(e2)
	end
	function UraraG.token2(c,cate,cost,tg,op)
		local code=c:GetOriginalCodeRule()
		--spsummon token
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,0))
		cate=cate or 0
		cate=cate+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN
		e2:SetCategory(cate)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e2:SetCountLimit(2,code)
		if cost then
			e2:SetCost(cost)
		end
		if tg then
			e2:SetTarget(tg)
		end
		e2:SetOperation(op)
		e2:SetLabel(14002381)
		c:RegisterEffect(e2)
	end
	function UraraG.UraraInGraveEffect1(c,cate,cost,con,tg,op)
		local code=c:GetOriginalCodeRule()
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(code,1))
		if cate then
			e3:SetCategory(cate)
		end
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetRange(LOCATION_GRAVE)
		e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e3:SetCountLimit(2,code)
		if cost then
			e3:SetCost(cost)
		end
		if con then
			e3:SetCondition(con)
		end
		if tg then
			e3:SetTarget(tg)
		end
		e3:SetOperation(op)
		c:RegisterEffect(e3)
	end
	function UraraG.chk_cost(tp,code)
		local ct=Duel.GetFlagEffect(tp,code)
		if ct>=3 then return false end
		if ct>=1 then
			if UraraG.get_available_field(tp,14002342)~=nil then
				return true
			end
			return Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
		end
		return true
	end
	function UraraG.pay_cost(tp,code)
		local ct=Duel.GetFlagEffect(tp,code)
		if ct>=1 then
			local fc=UraraG.get_available_field(tp,14002342)
			local has_counter=Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
			if fc and (not has_counter or Duel.SelectYesNo(tp,aux.Stringid(14002341,0))) then
				fc:RegisterFlagEffect(14002342,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			else
				Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_COST)
			end
		end
		Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
	end
	function UraraG.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCodeRule()
		if chk==0 then return UraraG.chk_cost(tp,code) end
		UraraG.pay_cost(tp,code)
	end
	function UraraG.deck_cost_filter(c)
		return UraraG.Urara(c) and c:IsAbleToGraveAsCost()
	end
	function UraraG.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCodeRule()
		if chk==0 then 
			return bit.band(r,REASON_COST)~=0 
				and re and re:GetLabel()==14002381
				and eg:IsContains(c)
				and c:GetDestination()==LOCATION_DECK
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,14002382,0,TYPES_TOKEN_MONSTER,2500,2500,5,RACE_FIEND,ATTRIBUTE_DARK)
				and UraraG.chk_cost(tp,code)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(code,3)) then
			UraraG.pay_cost(tp,code)
			Duel.Hint(HINT_CARD,0,code)
			local token=Duel.CreateToken(tp,14002382)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			return true
		else 
			return false 
		end
	end
	function UraraG.repval(e,c)
		return c==e:GetHandler()
	end
	function UraraG.lcheck(g,lc)
		return g:IsExists(Card.IsType,1,nil,TYPE_TOKEN)
	end
	function UraraG.is_external_exmat(c,lc,mg,tp)
		local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		for _,te in ipairs(le) do
			local h=te:GetHandler()
			if h and not h:IsCode(m) then
				local f=te:GetValue()
				if f then
					local related,valid=f(te,lc,mg,c,tp)
					if related and valid~=false then
						return true
					end
				end
			end
		end
		return false
	end
	function UraraG.is_goddess_opp(mc,lc,mg,tp)
		return mc:IsControler(1-tp) and not UraraG.is_external_exmat(mc,lc,mg,tp)
	end
	function UraraG.matval(e,lc,mg,c,tp)
		if e:GetHandler()~=lc then return false,nil end
		if not c:IsControler(1-tp) then return false,nil end
		if not mg then return true,true end
		if UraraG.is_external_exmat(c,lc,mg,tp) then return true,true end
		if mg:IsExists(UraraG.is_goddess_opp,1,c,lc,mg,tp) then return true,false end
		return true,true
	end
	function UraraG.synmatfilter(c)
		return c:IsType(TYPE_TOKEN) or c:IsType(TYPE_SYNCHRO)
	end
	function UraraG.stsynfilter(c,syncard)
		return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and UraraG.synmatfilter(c)
	end
	function UraraG.stsyngoal(g,target_lv,syncard)
		return g:GetSum(Card.GetSynchroLevel,syncard)==target_lv
	end
	function UraraG.stsyncon(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local lv=c:GetLevel()
		local remain=lv-1
		if remain<=0 then return false end
		if not Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_MATERIAL) then return false end
		local mg=Duel.GetMatchingGroup(UraraG.stsynfilter,tp,LOCATION_MZONE,0,nil,c)
		return mg:CheckSubGroup(UraraG.stsyngoal,1,99,remain,c)
	end
	function UraraG.stsyntg(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local lv=c:GetLevel()
		local remain=lv-1
		local mg=Duel.GetMatchingGroup(UraraG.stsynfilter,tp,LOCATION_MZONE,0,nil,c)
		local cancel=Duel.IsSummonCancelable()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,UraraG.stsyngoal,cancel,1,99,remain,c)
		if tg then
			tg:KeepAlive()
			e:SetLabelObject(tg)
			return true
		else
			return false
		end
	end
	function UraraG.stsynop(e,tp,eg,ep,ev,re,r,rp,c)
		local tg=e:GetLabelObject()
		if not tg then return end
		Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_MATERIAL+REASON_SYNCHRO)
		c:SetMaterial(tg)
		Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
		tg:DeleteGroup()
	end
	function UraraG.atkcon(e)
		local c=e:GetHandler()
		if not Duel.GetAttacker() then return end
		return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
	end
	function UraraG.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then
			local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
			if g:GetCount()==0 then return false end
			local g1,atk=g:GetMaxGroup(Card.GetBaseAttack)
			return not c:IsAttack(atk)
		end
	end
	function UraraG.atkop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
		if g:GetCount()==0 then return end
		local g1,atk=g:GetMaxGroup(Card.GetBaseAttack)
		if c:IsFaceup() and atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
		end
	end
	function UraraG.tdfilter(c)
		return UraraG.Hastur(c) and c:IsType(TYPE_MONSTER) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
	end
	function UraraG.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(UraraG.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,UraraG.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
	function UraraG.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,14002381,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_AQUA,ATTRIBUTE_WATER) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	end
	function UraraG.spop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,14002381,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_AQUA,ATTRIBUTE_WATER) then
			local token=Duel.CreateToken(tp,14002381)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(UraraG.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	function UraraG.aclimit(e,re,tp)
		return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsNonAttribute(ATTRIBUTE_WIND)
	end
end
if cm then
	cm.named_with_Urara=1
	function cm.initial_effect(c)
		--link
		c:EnableReviveLimit()
		aux.AddLinkProcedure(c,cm.matfilter,1,1)
		UraraG.atkchange(c)
		UraraG.token1(c)
		UraraG.UraraInGraveEffect1(c,CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE,nil,nil,cm.thtg,cm.thop)
	end
	function cm.matfilter(c)
		return c:IsType(TYPE_TOKEN) or (c:IsType(TYPE_MONSTER) and UraraG.Hastur(c))
	end
	function cm.rtfilter(c)
		return c:IsType(TYPE_TOKEN) and c:IsReleasable()
	end
	function cm.thfilter(c)
		return UraraG.Urara(c) and c:IsAbleToHand()
	end
	function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.rtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	function cm.thop(e,tp,eg,ep,ev,re,r,rp)
		local rg=Duel.SelectMatchingCard(tp,cm.rtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #rg>0 and Duel.Release(rg,REASON_COST)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end