--进化形兽 电石气鳄
local s,id,o=GetID()
local SET_METAFORM=0x9D71
local CARD_HYDROGEN_EAGLE=21401290
local CARD_MANAGER=21401291
local CARD_CARBON_CRAB=21401292
local CARD_OXYGEN_BULL=21401294

local MAT_H=0x1
local MAT_C=0x2
local MAT_O=0x4
local REQ_GAS=MAT_H|MAT_C

--「化形兽」融合怪兽专用多卡名素材代替
local EFFECT_METAFORM_FUSION_SUB=0x9D710100

function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)

	--融合召唤手续
	s.add_metafusion_proc(c,REQ_GAS,true,false,CARD_HYDROGEN_EAGLE,CARD_CARBON_CRAB)

	--接触融合：把自己场上的上记卡解放
	aux.AddContactFusionProcedure(c,s.contact_filter,LOCATION_ONFIELD,0,s.contact_op)

	--① 场上·墓地素材代替
	s.add_metafusion_sub(c,REQ_GAS)

	--② 自己的融合怪兽特殊召唤时，对方不能把效果发动
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.limcon)
	e2:SetOperation(s.limop)
	c:RegisterEffect(e2)

	--② 连锁结束后补锁
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2b:SetCode(EVENT_CHAIN_END)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetOperation(s.limop2)
	c:RegisterEffect(e2b)

	--③ 魔法·陷阱卡发动无效
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.negcon)
	e3:SetCost(s.negcost)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end

--==============================
-- 自定义融合素材系统
--==============================
function s.add_metafusion_proc(c,req,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local listed={...}
	local mat={}
	for _,code in ipairs(listed) do
		mat[code]=true
		aux.AddCodeList(c,code)
	end

	local mt=getmetatable(c)
	if mt.material==nil then
		mt.material=mat
	end
	if mt.material_count==nil then
		mt.material_count={1,s.req_count(req)}
	end

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(s.fuscon(req,sub,insf))
	e1:SetOperation(s.fusop(req,sub,insf))
	c:RegisterEffect(e1)
end

function s.req_count(req)
	local ct=0
	if (req&MAT_H)~=0 then ct=ct+1 end
	if (req&MAT_C)~=0 then ct=ct+1 end
	if (req&MAT_O)~=0 then ct=ct+1 end
	return ct
end

function s.regular_mask(c)
	local m=0
	if c:IsFusionCode(CARD_HYDROGEN_EAGLE) then m=m|MAT_H end
	if c:IsFusionCode(CARD_CARBON_CRAB) then m=m|MAT_C end
	if c:IsFusionCode(CARD_OXYGEN_BULL) then m=m|MAT_O end
	return m
end

function s.meta_mask(c,fc,req)
	local m=s.regular_mask(c)&req

	if fc:IsSetCard(SET_METAFORM) and fc:IsType(TYPE_FUSION) then
		local effs={c:IsHasEffect(EFFECT_METAFORM_FUSION_SUB)}
		for _,te in ipairs(effs) do
			m=m|(te:GetValue()&req)
		end
	end
	return m&req
end

function s.mat_filter(c,fc,summon_type,req,allow_sub,notfusion)
	--接触融合 / 自身解放手续：
	--只要求是自己场上的卡、能被解放、能代表所需卡名
	if notfusion then
		return c:IsLocation(LOCATION_ONFIELD)
			and c:IsControler(fc:GetControler())
			and c:IsReleasable(REASON_COST+REASON_MATERIAL)
			and s.meta_mask(c,fc,req)>0
	end

	--正规融合路线：
	--保持原本的融合素材要求，一般由融合魔法等效果限定为怪兽
	return c:IsCanBeFusionMaterial(fc,summon_type)
		and not c:IsHasEffect(6205579)
		and (
			s.meta_mask(c,fc,req)>0
			or (allow_sub and c:CheckFusionSubstitute(fc))
		)
end

function s.fuscon(req,sub,insf)
	return function(e,g,gc,chkfnf)
		if g==nil then
			return insf and aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL)
		end
		local fc=e:GetHandler()
		local tp=fc:GetControler()
		chkfnf=chkfnf or tp

		local hexsealed=(chkfnf&0x100)~=0
		local notfusion=(chkfnf&0x200)~=0
		local allow_sub=(sub or hexsealed) and not notfusion
		local summon_type=notfusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION

		local mg=g:Filter(s.mat_filter,nil,fc,summon_type,req,allow_sub,notfusion)
		if gc then
			if not mg:IsContains(gc) then return false end
			Duel.SetSelectedCard(gc)
		end
		return mg:CheckSubGroup(s.fusion_goal,1,s.req_count(req),tp,fc,req,chkfnf,allow_sub)
	end
end

function s.fusop(req,sub,insf)
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
		local fc=e:GetHandler()
		chkfnf=chkfnf or tp

		local hexsealed=(chkfnf&0x100)~=0
		local notfusion=(chkfnf&0x200)~=0
		local allow_sub=(sub or hexsealed) and not notfusion
		local summon_type=notfusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION
		local cancel=notfusion and Duel.GetCurrentChain()==0

		local mg=eg:Filter(s.mat_filter,nil,fc,summon_type,req,allow_sub,notfusion)
		if gc then
			Duel.SetSelectedCard(gc)
		end

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:SelectSubGroup(tp,s.fusion_goal,cancel,1,s.req_count(req),tp,fc,req,chkfnf,allow_sub)
		if sg then
			Duel.SetFusionMaterial(sg)
		else
			Duel.SetFusionMaterial(Group.CreateGroup())
		end
	end
end

function s.fusion_goal(sg,tp,fc,req,chkfnf,allow_sub)
	local chkf=chkfnf&0xff
	local not_fusion=(chkfnf&(0x100|0x200))~=0

	if not not_fusion and sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then
		return false
	end
	if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then
		return false
	end
	if chkf~=PLAYER_NONE and Duel.GetLocationCountFromEx(tp,tp,sg,fc)<=0 then
		return false
	end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc) then
		return false
	end
	if aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc) then
		return false
	end

	return s.meta_goal(sg,fc,req)
		or s.normal_sub_goal(sg,fc,req,allow_sub)
end

function s.meta_goal(sg,fc,req)
	local masks={}
	for tc in aux.Next(sg) do
		local m=s.meta_mask(tc,fc,req)
		if m==0 then return false end
		table.insert(masks,m)
	end

	if #masks>s.req_count(req) then return false end

	return s.meta_assign(masks,1,req)
end

function s.meta_assign(masks,idx,remain)
	if idx>#masks then
		return remain==0
	end

	local can=masks[idx]&remain
	if can==0 then return false end

	local sub=can
	while sub>0 do
		if s.meta_assign(masks,idx+1,remain-sub) then
			return true
		end
		sub=(sub-1)&can
	end
	return false
end

function s.normal_sub_goal(sg,fc,req,allow_sub)
	if not allow_sub then return false end
	if sg:GetCount()~=s.req_count(req) then return false end

	for subc in aux.Next(sg) do
		if subc:CheckFusionSubstitute(fc) and not subc:IsHasEffect(6205579) then
			local regular=0
			local ok=true
			for tc in aux.Next(sg) do
				if tc~=subc then
					local m=s.regular_mask(tc)&req
					if m==0 then
						ok=false
						break
					end
					regular=regular|m
				end
			end
			if ok then
				for _,bit in ipairs({MAT_H,MAT_C,MAT_O}) do
					if (req&bit)~=0 then
						local need=req-bit
						if (regular&need)==need then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

--==============================
-- 接触融合
--==============================
function s.contact_filter(c,fc)
	return c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(fc:GetControler())
		and c:IsReleasable(REASON_COST+REASON_MATERIAL)
		and s.meta_mask(c,fc,REQ_GAS)>0
end

function s.contact_op(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end

--==============================
-- ① 素材代替
--==============================
function s.add_metafusion_sub(c,mask)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_METAFORM_FUSION_SUB)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(mask)
	c:RegisterEffect(e1)
end

--==============================
-- ② 对方不能把效果发动
--==============================
function s.limfilter(c,tp)
	return c:IsControler(tp)
		and c:IsFaceup()
		and c:IsType(TYPE_FUSION)
end

function s.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.limfilter,1,nil,tp)
end

function s.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.limfilter,nil,tp)

	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))

	for tc in aux.Next(g) do
		tc:SetHint(CHINT_DESC,aux.Stringid(id,1))
	end

	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)

		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.resetop)
		Duel.RegisterEffect(e1,tp)

		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end

function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end

function s.limop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
	c:ResetFlagEffect(id)
end

function s.chainlm(e,rp,tp)
	return rp==tp
end

--==============================
-- ③ 魔法·陷阱卡发动无效
--==============================
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
