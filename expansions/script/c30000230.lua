--灭绝机 霍拉格
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30000230)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.FALSE)
	local e1=rsef.I(c,{m,0},nil,"dr","ptg",LOCATION_HAND,nil,rscost.cost(Card.IsAbleToDeckAsCost,"td"),rsop.target(1,"dr"),cm.drop)
	local e2=rsef.I(c,{m,0},nil,"td",nil,LOCATION_GRAVE,nil,nil,rsop.target({Card.IsAbleToDeck,"td"},{1,"dr"}),cm.tdop)
	local e3=rsef.FTO(c,m,{m,1},nil,"sp","de",LOCATION_DECK,cm.spcon,cm.spcost,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(0xff)
	e4:SetValue(cm.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(0xff)
	e5:SetValue(cm.effectfilter)
	c:RegisterEffect(e5)
	if cm.gf then return end
	cm.gf=true  
	local ge1=rsef.FC({c,0},EVENT_DESTROYED)
	ge1:SetOperation(cm.regop)
	local ge2=rsef.RegisterClone({c,0},ge1,"code",EVENT_REMOVE)
	local ge3=rsef.FC({c,0},EVENT_CHAIN_NEGATED)
	ge3:SetOperation(cm.regop2)
	local ge4=rsef.RegisterClone({c,0},ge3,"code",EVENT_CHAIN_DISABLED)
end
function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function cm.drop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,1,REASON_EFFECT)
end
function cm.tdop(e,tp)
	local c=rscf.GetSelf(e)
	if c and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.cfilter(c,rp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()~=rp
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if rp==i and eg:IsExists(cm.cfilter,1,nil,rp) then
			local flag=0
			for tc in aux.Next(eg) do 
				if cm.cfilter(tc,rp) then
					if not flag then flag=0 end
					if tc:IsOriginalComplexType(TYPE_SPELL) then
						flag=TYPE_SPELL 
					elseif tc:IsOriginalComplexType(TYPE_TRAP) then
						flag=TYPE_TRAP 
					elseif tc:IsOriginalComplexType(TYPE_MONSTER) then
						flag=TYPE_MONSTER 
					end
				end
			end
			Duel.RegisterFlagEffect(1-rp,m,rsreset.pend,0,1,flag)
		end
	end
	for i=0,1 do
		if Duel.GetFlagEffect(i,m)>=2 then
			Duel.RaiseEvent(eg,m,re,r,rp,ep,ev)
		end
	end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local flag=0
	if rc:IsOriginalComplexType(TYPE_SPELL) then
		flag=TYPE_SPELL 
	elseif rc:IsOriginalComplexType(TYPE_TRAP) then
		flag=TYPE_TRAP 
	elseif rc:IsOriginalComplexType(TYPE_MONSTER) then
		flag=TYPE_MONSTER 
	end
	Duel.RegisterFlagEffect(ep,m,rsreset.pend,0,1,flag)
	if Duel.GetFlagEffect(ep,m)>=2 then
		Duel.RaiseEvent(re:GetHandler(),m,re,r,1-ep,ep,ev)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+100)==0 end
	Duel.RegisterFlagEffect(tp,m+100,RESET_CHAIN,0,1)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.spop(e,tp,eg)
	local c=rscf.GetSelf(e)
	if not c or rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)<=0 then return end
	c:CompleteProcedure()
	local flaglist={Duel.GetFlagEffectLabel(tp,m)}
	local flag=0
	for _,v in pairs(flaglist) do
		flag=flag|v
	end
	if flag & TYPE_MONSTER ~=0 then
		local e1=rsef.QO({c,nil,true},nil,{m,0},1,"dr","ptg",LOCATION_MZONE,nil,nil,rsop.target(1,"dr"),cm.drop,nil,rsreset.est)
	end
	if flag & TYPE_SPELL ~=0 then
		local e2=rsef.QO({c,nil,true},nil,{m,2},1,"tg",nil,LOCATION_MZONE,nil,nil,rsop.target(Card.IsAbleToGrave,"tg",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.tgop,nil,rsreset.est)
	end
	if flag & TYPE_TRAP ~=0 then
		local e3=rsef.QO({c,nil,true},nil,{m,3},1,"tg",nil,LOCATION_MZONE,nil,nil,rsop.target(Card.IsAbleToHand,"th",LOCATION_GRAVE,LOCATION_GRAVE),cm.thop,nil,rsreset.est)
	end
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,{tp})
end