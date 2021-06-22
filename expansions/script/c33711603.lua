--真贱胜负
local m=33711603
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.atktg1)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1) 
end
cm.toss_coin=true
function cm.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,1-tp,1)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local flag=false
	local flag_1=false
	local t_flag_1=true
	local t_flag_2=true
	local tossp=1-tp
	local num=0
	while (flag==false and flag_1==false) do
		tossp=1-tossp
		num=num+1
		Duel.Hint(HINT_SELECTMSG,tossp,HINTMSG_COIN)
		local coin=Duel.AnnounceCoin(1-tossp)
		local coin_1=Duel.AnnounceCoin(tossp)
		local res=Duel.TossCoin(tossp,1)
		local res_1=Duel.TossCoin(1-tossp,1)
		if coin==res then
			Duel.Damage(1-tossp,500*num,REASON_EFFECT)
			t_flag_1=false
		else
			flag=true
		end
		if coin_1==res_1 then
			Duel.Damage(tossp,500*num,REASON_EFFECT)
			t_flag_2=false
		else
			flag_1=true
		end
		if t_flag_1==false and Duel.SelectYesNo(1-tossp,aux.Stringid(m,2)) then
			flag=false
			t_flag_2=true
		end
		if t_flag_2==false and Duel.SelectYesNo(tossp,aux.Stringid(m,2)) then
			flag_1=false
		end
		t_flag_1=true
		t_flag_2=true
	end
end